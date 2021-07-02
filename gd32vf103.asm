# GD32VF103 Manual: Section 5.3
RCU_BASE_ADDR = 0x40021000

# GD32VF103 Manual: Section 5.3.7
RCU_APB2EN_OFFSET   = 0x18
RCU_APB2EN_AFEN_BIT = 0
RCU_APB2EN_PAEN_BIT = 2
RCU_APB2EN_PBEN_BIT = 3
RCU_APB2EN_PCEN_BIT = 4
RCU_APB2EN_PDEN_BIT = 5
RCU_APB2EN_PEEN_BIT = 6
RCU_APB2EN_SPI0EN_BIT = 12
RCU_APB2EN_USART0EN_BIT = 14

RCU_APB2EN_SPI0EN = (1 << RCU_APB2EN_SPI0EN_BIT )

# GD32VF103 Manual: Section 7.5
AFIO_BASE_ADDR   = 0x40010000

GPIO_BASE_ADDR_A = 0x40010800  # GD32VF103 Manual: Section 7.5 (green and blue LEDs)
GPIO_BASE_ADDR_B = 0x40010C00
GPIO_BASE_ADDR_C = 0x40011000  # GD32VF103 Manual: Section 7.5 (red LED)
GPIO_BASE_ADDR_D = 0x40011400 
GPIO_BASE_ADDR_E = 0x40011800 

GPIO_CTL0_OFFSET  = 0x00 # GPIO port control register 0
GPIO_CTL1_OFFSET  = 0x04 # GPIO port control register 1
GPIO_ISTAT_OFFSET = 0x08 # GPIO port input status register
GPIO_OCTL_OFFSET  = 0x0C # GPIO port output control register
GPIO_BOP_OFFSET   = 0x10 # GPIO port bit operation register
GPIO_BC_OFFSET    = 0x14 # GPIO bit clear register 

# GD32VF103 Manual: Section 7.3
GPIO_MODE_IN        = 0b00
GPIO_MODE_OUT_10MHZ = 0b01
GPIO_MODE_OUT_2MHZ  = 0b10
GPIO_MODE_OUT_50MHZ = 0b11

# GD32VF103 Manual: Section 7.3
GPIO_CTL_IN_ANALOG    = 0b00
GPIO_CTL_IN_FLOATING  = 0b01
GPIO_CTL_IN_PULL_DOWN = 0b10
GPIO_CTL_IN_PULL_UP   = 0b11

# GD32VF103 Manual: Section 7.3
GPIO_CTL_OUT_PUSH_PULL      = 0b00
GPIO_CTL_OUT_OPEN_DRAIN     = 0b01
GPIO_CTL_OUT_ALT_PUSH_PULL  = 0b10
GPIO_CTL_OUT_ALT_OPEN_DRAIN = 0b11

# combined CTL[1:0], MD[1:0]  for config and mode
GPIO_MODE_IN_ANALOG   = 0x0 #  analog input 
GPIO_MODE_PP_10MHZ    = 0x1 #  push-pull output, max speed 10MHz
GPIO_MODE_PP_2MHZ     = 0x2 #  push-pull output, max speed 2MHz
GPIO_MODE_PP_50MHZ    = 0x3 #  push-pull output, max speed 50MHz
GPIO_MODE_IN_FLOAT    = 0x4 #  floating input 
GPIO_MODE_OD_10MHZ    = 0x5 #  open-drain output, max speed 10MHz
GPIO_MODE_OD_2MHZ     = 0x6 #  open-drain output, max speed 2MHz
GPIO_MODE_OD_50MHZ    = 0x7 #  open-drain output, max speed 50MHz
GPIO_MODE_IN_PULL     = 0x8 #  input with pull up/down
GPIO_MODE_AF_PP_10MHZ = 0x9 #  alternate function push-pull, max speed 10MHz
GPIO_MODE_AF_PP_2MHZ  = 0xa #  alternate function push-pull, max speed 2MHz
GPIO_MODE_AF_PP_50MHZ = 0xb #  alternate function push-pull, max speed 50MHz
GPIO_MODE_AF_OD_10MHZ = 0xd #  alternate function open-drain, max speed 10MHz
GPIO_MODE_AF_OD_2MHZ  = 0xe #  alternate function open-drain, max speed 2MHz
GPIO_MODE_AF_OD_50MHZ = 0xf #  alternate function open-drain, max speed



# GD32VF103 Manual: Section 16.4
USART_BASE_ADDR_0 = 0x40013800

# GD32VF103 Manual: Section 16.4.1
USART_STAT_OFFSET   = 0x00
USART_STAT_RBNE_BIT = 5
USART_STAT_TBE_BIT  = 7

# GD32VF103 Manual: Section 16.4.2
USART_DATA_OFFSET = 0x04

# GD32VF103 Manual: Section 16.4.3
USART_BAUD_OFFSET = 0x08

# GD32VF103 Manual: Section 16.4.4
USART_CTL0_OFFSET = 0x0c
USART_CTL0_REN_BIT = 2
USART_CTL0_TEN_BIT = 3
USART_CTL0_UEN_BIT = 13

  
RCU_BASE_ADDR      = 0x40021000  # GD32VF103 Manual: Section 5.3
RCU_CTL_OFFSET     = 0x00  
RCU_CFG0_OFFSET    = 0x04
RCU_INT_OFFSET     = 0x08
RCU_APB2RST_OFFSET = 0x0c
RCU_APB1RST_OFFSET = 0x10
RCU_AHBEN_OFFSET   = 0x14
RCU_APB2EN_OFFSET  = 0x18  # GD32VF103 Manual: Section 5.3.7
RCU_APB1EN_OFFSET  = 0x1c
RCU_BDCTL_OFFSET   = 0x20
RCU_RSTSCK_OFFSET  = 0x24
RCU_AHBRST_OFFSET  = 0x28
RCU_CFG1_OFFSET    = 0x2c 
RCU_APB2RST_SPI0RST = (1<<12) #SPI0 reset 

RCU_CFG0_PLLMF_Msk      = 0x203c0000
RCU_CFG0_AHBPSC_Msk     = 0xf0
RCU_CFG0_APB2PSC_Msk    = 0x3800
RCU_CFG0_APB1PSC_Msk    = 0x700
RCU_CFG0_SCS_Msk        = 0x3
RCU_CFG0_SCSS_Msk       = 0xc

RCU_CFG0_APB1PSC_Pos    = 8
RCU_CFG0_PLLMF_Pos      = 18
RCU_CFG0_PLLMF_4_Pos    = 29
RCU_CFG0_SCSS_Pos       = 2

RCU_CFG0_SCSS_PLL       = (2 << RCU_CFG0_SCSS_Pos)
RCU_CFG0_PLLMF_MUL24    = ( ((23 & 0xf) << RCU_CFG0_PLLMF_Pos) | (( 23 >> 4) << RCU_CFG0_PLLMF_4_Pos ))
RCU_CFG0_PLLMF_MUL27    = ( ((26 & 0xf) << RCU_CFG0_PLLMF_Pos) | (( 26 >> 4) << RCU_CFG0_PLLMF_4_Pos ))
RCU_CFG0_PLLSEL         = ( 1 << 13)
RCU_CTL_PLLEN           = ( 1 << 24 )
RCU_CFG0_APB1PSC_DIV2   = (4 << RCU_CFG0_APB1PSC_Pos)
RCU_CFG0_SCS_PLL        = 2
    
SPI0_BASE_ADDR          = 0x40013000
SPI1_BASE_ADDR          = 0x40003800  # GD32VF103 Manual: Section 18.11
SPI_STAT_TBE_BIT        = 1
SPI_STAT_TBE            = (1 << SPI_STAT_TBE_BIT)
SPI_STAT_TRANS_BIT      = 7
SPI_STAT_TRANS          = (1 << SPI_STAT_TRANS_BIT)
SPI_CTL0_OFFSET         = 0x00  # GD32VF103 Manual: Section 18.11.1
SPI_CTL1_OFFSET         = 0x04  # GD32VF103 Manual: Section 18.11.2
SPI_STAT_OFFSET         = 0x08  # GD32VF103 Manual: Section 18.11.3
SPI_DATA_OFFSET         = 0x0c  # GD32VF103 Manual: Section 18.11.4

SPI_CTL0_BDEN_BIT       = 15
SPI_CTL0_BDOEN_BIT      = 14
SPI_CTL0_SWNSSEN_BIT    =  9
SPI_CTL0_SWNSS_BIT      =  8
SPI_CTL0_SPIEN_BIT      =  6
SPI_CTL0_MSTMOD_BIT     =  2
SPI_CTL0_CKPL_BIT       =  1
SPI_CTL0_CKPH_BIT       =  0
SPI_CTL0_PSC_Pos        =  3

SPI_CTL0_BDEN       = (1 << SPI_CTL0_BDEN_BIT)
SPI_CTL0_BDOEN      = (1 << SPI_CTL0_BDOEN_BIT)
SPI_CTL0_SWNSSEN    = (1 << SPI_CTL0_SWNSSEN_BIT)
SPI_CTL0_SWNSS      = (1 << SPI_CTL0_SWNSS_BIT)
SPI_CTL0_SPIEN      = (1 << SPI_CTL0_SPIEN_BIT)
SPI_CTL0_MSTMOD     = (1 << SPI_CTL0_MSTMOD_BIT)
SPI_CTL0_CKPL       = (1 << SPI_CTL0_CKPL_BIT)
SPI_CTL0_CKPH       = (1 << SPI_CTL0_CKPH_BIT)

DP_CLOCKDIV_WRITE   =  (2 << SPI_CTL0_PSC_Pos)

MTIMER_BASE     = 0xD1000000

MTIMER_MTIME_LO_OFFSET      = 0x00
MTIMER_MTIME_HI_OFFSET      = 0x04
MTIMER_MTIMECMP_LO_OFFSET   = 0x08
MTIMER_MTIMECMP_HO_OFFSET   = 0x0c


# GD32VF103 Manual: page 111 
# LCD protocol
# PORT B
DP_DC_BIT   = 0 
DP_RST_BIT  = 1
DP_CS_BIT   = 2
DP_DC       = (1 << DP_DC_BIT) 
DP_RST      = (1 << DP_RST_BIT) 
DP_CS       = (1 << DP_CS_BIT) 

# PORT A
DP_SDA_BIT  = 7
DP_SCL_BIT  = 5
DP_SDA      = (1 << DP_SDA_BIT)
DP_SCL      = (1 << DP_SCL_BIT)
