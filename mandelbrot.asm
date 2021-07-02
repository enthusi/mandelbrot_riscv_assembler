
include gd32vf103.asm

# No IRQs enables, hence we need no ISR tables
# and the code starts right away at 0 offset which
# is the RESET vector!

RAM = 0x20000000
MEM_SIZE = 0x8000
STACK = RAM + MEM_SIZE

#==============================================
sp_init:
    li sp, STACK
main:
    jal rcu_init
    jal dp_init
    jal dp_on 
    j mandelbrot
    
    
#==============================================    
rcu_init:
    li a5, RCU_BASE_ADDR
    lw a4, RCU_CFG0_OFFSET(a5)

    #first mask out relevant bits
    li a3, ~( RCU_CFG0_PLLMF_Msk | RCU_CFG0_PLLSEL | RCU_CFG0_AHBPSC_Msk | RCU_CFG0_APB2PSC_Msk | RCU_CFG0_APB1PSC_Msk)
    and	a4, a4, a3
    #set core clock!
    li a0, (RCU_CFG0_PLLMF_MUL27 | RCU_CFG0_APB1PSC_DIV2) 
    or a0, a4, a0
    sw a0, RCU_CFG0_OFFSET(a5)
    
    lw a4, RCU_CTL_OFFSET(a5)
    li a3, RCU_CTL_PLLEN
    or a4, a4, a3
    sw a4, RCU_CTL_OFFSET(a5)
       
rcu_sysclk_pll_irc8m_loop1:
    lw a4, RCU_CTL_OFFSET(a5)
    slli a3, a4, 6 #while (!(RCU->CTL & RCU_CTL_PLLSTB))
    bgez a3, rcu_sysclk_pll_irc8m_loop1 #wait until PLL is stable
    
    #RCU->CFG0 = (RCU->CFG0 & ~RCU_CFG0_SCS_Msk) | RCU_CFG0_SCS_PLL;
    lw a4, RCU_CFG0_OFFSET(a5)
    andi a4, a4, ~RCU_CFG0_SCS_Msk
    ori a4, a4, RCU_CFG0_SCS_PLL
    sw a4, RCU_CFG0_OFFSET(a5)
    
    li a4, RCU_CFG0_SCSS_PLL
rcu_sysclk_pll_irc8m_loop2:
    lw a3, RCU_CFG0_OFFSET(a5) #wait until PLL is selected as system clock
    andi a3, a3, RCU_CFG0_SCSS_Msk #while ((RCU->CFG0 & RCU_CFG0_SCSS_Msk) != RCU_CFG0_SCSS_PLL)
    bne a3, a4, rcu_sysclk_pll_irc8m_loop2
    ret
  
#=================================================
dp__setbox:
    addi sp,sp,-16
    sw ra,0(sp)
    
    addi s0, a3, 25
    addi s1, a2, 26
    addi s2, a1, 0
    addi s3, a0, 1

    li a0, 0x2a #column addres 0x2a
    jal dp__cmd
    #s3 assumed to be 16bit here!
    #column start
    #srli	a0,s3,8   
    #andi	a0,a0,255
    li a0, 0 #high byte always 0 for longan nano LCD!
    jal dp__write
    andi a0, s3, 255
    jal dp__write
    #column end
    #srli	a0,s2,8
    #andi	a0,a0,255
    li a0, 0
    jal dp__write
    andi a0, s2, 255
    jal dp__write

    li a0, 0x2b #row address 0x2b
    jal dp__cmd
    #16 bit row start
    #srli	a0,s1,8
    #andi	a0,a0,255
    li a0, 0
    jal dp__write
    andi a0, s1, 255
    jal dp__write
    #row end
    #srli	a0,s0,8
    #andi	a0,a0,255
    li a0, 0
    jal dp__write
    andi a0, s0, 255
    jal dp__write
    
    li	a0, 0x2c #mem write
    jal dp__cmd #0x2c
    
    lw ra, 0(sp)
    addi sp, sp, 16
    ret
#=================================================
dp_init:
    addi sp, sp, -16
    sw ra, 0(sp)
    
    #RCU->APB2EN |= RCU_APB2EN_PAEN | RCU_APB2EN_PBEN;
    li s0, RCU_BASE_ADDR
    lw a5, RCU_APB2EN_OFFSET(s0)
    ori a5, a5, ( (1<<RCU_APB2EN_PAEN_BIT) | (1<<RCU_APB2EN_PBEN_BIT))
    sw a5, RCU_APB2EN_OFFSET(s0)
    
    #RCU->APB2EN |= RCU_APB2EN_AFEN | RCU_APB2EN_SPI0EN;
    lw a4, RCU_APB2EN_OFFSET(s0)
    li a5, ((1<<RCU_APB2EN_AFEN_BIT) | (1<<RCU_APB2EN_SPI0EN_BIT))
    or a4, a4, a5
    sw a4, RCU_APB2EN_OFFSET(s0)
    
    #gpio_pin_set(DP_CS);
    li s2, GPIO_BASE_ADDR_B
    li s5, DP_CS 
    sw s5, GPIO_BOP_OFFSET(s2) 
    #gpio_pin_config(DP_CS, GPIO_MODE_PP_50MHZ);
    li a1, GPIO_MODE_PP_50MHZ
    li  s5, 2
    jal gpio_pin_config #000103f0
    
    #activate reset
    li s5, DP_RST
    sw s5, GPIO_BC_OFFSET(s2) #CLEAR
    li a1, GPIO_MODE_PP_50MHZ
    li s5, 1#17
    jal gpio_pin_config
    
    li a5, DP_DC
    sw a5, GPIO_BOP_OFFSET(s2) #SET
    li a1, GPIO_MODE_PP_50MHZ
    li s5, 0#16
    jal gpio_pin_config
    
    li s2, GPIO_BASE_ADDR_A#port A for SCL/SDA
    li a5, DP_SCL
    sw a5, GPIO_BOP_OFFSET(s2) #SET
    li a1, GPIO_MODE_AF_PP_50MHZ
    li s5, 5
    jal gpio_pin_config
    
    li a5, DP_SDA
    sw a5, GPIO_BC_OFFSET(s2) #CLEAR
    li a1, GPIO_MODE_AF_PP_50MHZ
    li s5, 7
    jal gpio_pin_config
   
    li a5, RCU_BASE_ADDR 
    li a3, RCU_APB2RST_SPI0RST 
    lw a4, RCU_APB2RST_OFFSET(a5)
    or a4, a4, a3
    sw a4, RCU_APB2RST_OFFSET(a5)
    not a3, a3
    and a4, a4, a3
    sw a4, RCU_APB2RST_OFFSET(a5)
    
    li a5, SPI0_BASE_ADDR
    li a3, ( DP_CLOCKDIV_WRITE | SPI_CTL0_BDEN | SPI_CTL0_BDOEN | SPI_CTL0_SWNSSEN | SPI_CTL0_SWNSS | SPI_CTL0_MSTMOD | SPI_CTL0_CKPL | SPI_CTL0_CKPH )
    sw a3, SPI_CTL0_OFFSET(a5)
    sw zero, SPI_CTL1_OFFSET(a5)
    ori a3, a3, SPI_CTL0_SPIEN
    sw a3, SPI_CTL0_OFFSET(a5)
    
    li a0, 15
    jal dp_udelay #delays a0 (a3,a4,a5)
    
    #release reset
    li s2, GPIO_BASE_ADDR_B
    li s5, DP_RST
    sw s5, GPIO_BOP_OFFSET(s2)
   
    li a0, 120000
    jal dp_udelay
    
    jal dp_sleep_out
    
    li a0, 120000
    jal dp_udelay
  
    #cs_enable = clear
    li s2, GPIO_BASE_ADDR_B
    li s5, DP_CS 
    sw s5, GPIO_BC_OFFSET(s2) #clear
    
    li s0, lcd_init_data
cmd_loop:    
    #get counter first
    lbu t0, 0(s0)
    addi s0, s0, 1
    
    #get cmd
    lbu t1,0(s0)
    beqz t1, init_done #0 terminated
    addi s0, s0, 1
    
    #now read and write data in a loop
    #write cmd
    mv a0, t1
    jal dp__cmd
data_loop:    
    addi t0, t0, -1
    beqz t0, this_cmd_done
    lbu t1, 0(s0)
    addi s0, s0, 1
    mv a0, t1
    jal dp__write #a4,a5,a0
    j data_loop
this_cmd_done:
    j cmd_loop
init_done:
    jal dp_cs_disable
    lw ra, 0(sp)
    addi sp, sp, 16
    ret
      
#==================================================    
dp__write:
    li a4, SPI0_BASE_ADDR
dp__write_loop:
    lw a5, SPI_STAT_OFFSET(a4)
    andi a5, a5, SPI_STAT_TBE
    beqz a5, dp__write_loop
    sw a0, SPI_DATA_OFFSET(a4) #write data in a0    
    ret

dp_sleep_out:
    li a0, 0x11
    j dp_cmd

dp_on:
    li a0,41
    j dp_cmd
 
dp_cmd: 
    addi sp, sp, -16
    sw ra, 0(sp)
    
    li a5, GPIO_BASE_ADDR_B
    li a4, DP_CS 
    sw a4, GPIO_BC_OFFSET(a5)
    
    jal dp__cmd
    lw ra, 0(sp)
    addi sp, sp, 16
    j dp_cs_disable

dp_cs_disable:
    li a4, SPI0_BASE_ADDR
dp_cs_disable_label:
    lw a5, SPI_STAT_OFFSET(a4)
    andi a5, a5, SPI_STAT_TRANS
    bnez a5, dp_cs_disable_label #wait while (spi_transmitting())
    li s5, GPIO_BASE_ADDR_B
    li s4, DP_CS 
    sw s4, GPIO_BOP_OFFSET(s5) #SET
    ret
    
dp__cmd:
    li a4, SPI0_BASE_ADDR
dp__cmd_loop:
    lw a5, SPI_STAT_OFFSET(a4)
    andi a5, a5, SPI_STAT_TRANS #wait till spi transmission is over
    bnez a5, dp__cmd_loop 
    li a5, GPIO_BASE_ADDR_B
    li a3, DP_DC 
    sw a3, GPIO_BC_OFFSET(a5) #clear
    sw a0, SPI_DATA_OFFSET(a4) #;write command
    
dp__cmd_loop2:
    lw a5, SPI_STAT_OFFSET(a4)
    andi a5, a5, SPI_STAT_TRANS #wait till spi transmission is over
    bnez a5, dp__cmd_loop2 #data written?
    li s5, GPIO_BASE_ADDR_B
    li s4, DP_DC 
    sw s4, GPIO_BOP_OFFSET(s5) #SET
    ret

dp_udelay:
    li a5, MTIMER_BASE
    lw a4, MTIMER_MTIME_LO_OFFSET(a5) # reference time
    li a3, 27 #CORECLOCK/4.000.000 = 27 (108 Mhz) or 24 for 96 Mhz
    mul a0, a0, a3 #us to clock count
dp_delay_wait_loop:
    lw a3, MTIMER_MTIME_LO_OFFSET(a5) 
    sub a3, a3, a4 #now - reference time
    bltu a3, a0, dp_delay_wait_loop
    ret

#=================================================
gpio_pin_config:
    # Func: gpio_init
    # Arg: s2 = GPIO port base addr
    # Arg: s5 = GPIO pin number
    # Arg: a1 = GPIO config (4 bits)

    # advance to CTL0
    addi t0, s2, GPIO_CTL0_OFFSET
    # if pin number is less than 8, CTL0 is correct
    slti t1, s5, 8
    bnez t1, gpio_config
    # else we need CTL1 and then subtract 8 from the pin number
    addi t0, t0, 4
    addi s5, s5, -8
gpio_config:
    # multiply pin number by 4 to get shift amount
    slli s5,s5,2
    # load current config
    lw t1, 0(t0)
    # align and clear existing pin config
    li t2, 0b1111
    sll t2, t2, s5
    not t2, t2
    and t1, t1, t2
    # align and apply new pin config
    sll a1, a1, s5
    or t1, t1, a1
    # store updated config
    sw t1, 0(t0)
    ret

#==========================================
lcd_init_data: 

#format: count, command, data
bytes  1, 0x21 #display on
bytes   4, 0xb1, 0x05, 0x3a, 0x3a #Frame Rate Control (In normal mode/ Full colors)
bytes   4, 0xb2, 0x05, 0x3a, 0x3a #Frame Rate Control (In Idle mode/ 8-colors)
bytes   7, 0xb3, 0x05, 0x3a, 0x3a, 0x05, 0x3a, 0x3a #Frame Rate Control (In Partial mode/ full colors)
bytes   2, 0xb4, 0x03 #Display Inversion Control
bytes   4, 0xc0, 0x62, 0x02, 0x04 #Power Control 1
bytes   2, 0xc1, 0xc0 #Power Control 2
bytes   3, 0xc2, 0x0d, 0x00 #Power Control 3
bytes   3, 0xc3, 0x8d, 0x6a #Power Control 4
bytes   3, 0xc4, 0x8d, 0xee #Power Control 5
bytes   2, 0xc5, 0x0e #COM Control 1
bytes   17, 0xe0, 0x10, 0x0e, 0x02, 0x03 #Gamma (‘+’polarity) Correction Characteristics Setting
bytes       0x0e, 0x07, 0x02, 0x07
bytes       0x0a, 0x12, 0x27, 0x37
bytes       0x00, 0x0d, 0x0e, 0x10
bytes   17, 0xe1, 0x10, 0x0e, 0x03, 0x03 #Gamma ‘-’polarity Correction Characteristics Setting
bytes       0x0f, 0x06, 0x02, 0x08
bytes       0x0a, 0x13, 0x26, 0x36
bytes       0x00, 0x0d, 0x0e, 0x10
bytes   2, 0x36, 0xa8 #DP_MADCTL,Memory Data Access Control rientation 08, c8, 78, a8
#bytes		2, 0x3a, 0x03#, /* dp__mode444() */
bytes   2, 0x3a, 0x05#, /* dp__mode565() */
bytes   0 #end of data
#==========================================
align 2

mandelbrot:
    
    li  a5, GPIO_BASE_ADDR_B
    li  a4, DP_CS 
    sw	a4, GPIO_BC_OFFSET(a5) #clear
    
    #10 is basically the visible offset!
    li	a0,00 #col start confirmed
    li	a1,160 #col end confirmed
    li	a2,0 #row start
    li	a3,80 #row end
    jal dp__setbox 
    
do_math:
    #++++++++++++++++++++++++++++++++++++++++++++++
    #fixpoint math with 2.13 bit precision.
    li a1,-18337-1000+2000 #-0.7 * 2**13 - 3.0769*2**12)
    li a2, 6869+1000 +2000
    li a3, -10000
    li a4, 10000
    
    li t3,16384 
    li t4,268435456 # mandelbrot threshold
   
    #s2=xstep
    #s3=ystep 
    #s4 divider 5
    li s4,5
    sub s2,a2,a1 #(xmax-xmin)
    div s2,s2,s4 #32/SCREEN_WIDTH = /5

    sub s3,a4,a3 #(xmax-xmin)
    div s3,s3,s4 #32/SCREEN_WIDTH = /5
    
    li s5,0 #Y
loopy:
    #s7 = q
    mul s7,s5,s3 #y*ys
    srai s7,s7,4 #/16
    add s7,s7,a3 #+ymin
    li s6,0 #X

loopx:
    #s8 = p
    mul s8,s6,s2 #x*xs
    srai s8,s8,5 #/32
    add s8,s8,a1 #+xmin

    li s9,0#xn
    li s10,0#x0
    li s11,0#y0
    
    li t2,128 #maxiter
innerloop:
    #xn=mul((x0+y0),(x0-y0)) +p;
    add t0,s10,s11
    sub t1,s10,s11
    mul s9,t0,t1
    srai s9,s9,13
    add s9,s9,s8

    #y0=mul(32768,mul(x0,y0)) +q;
    mul t0,s10,s11
    srai t0,t0,13
    mul s11,t3,t0
    srai s11,s11,13
    add s11,s11,s7

    #x0=xn;
    mv s10,s9

    #((mul(xn,xn)+mul(y0,y0))<(65536)
    mul t0,s9,s9 #xn**2
    mul t1,s11,s11 #y0**2
    add t0,t0,t1

    bgt t0,t4, exitloop
    addi t2,t2,-1
    bne t2,zero,innerloop

exitloop:
    mv a0,t2
    jal dp__write #a5,a4,a0
    jal dp__write

    #next x
    addi s6,s6,1
    li t0,160
    bne s6,t0,loopx

    #next y
    addi s5,s5,1
    li t0,80
    bne s5,t0,loopy
    #++++++++++++++++++++++++++++++++++++++++++++++
    jal dp_cs_disable
end:
    j end
