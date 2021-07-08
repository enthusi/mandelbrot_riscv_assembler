SOURCE=mandelbrot
SOURCE_DEV=j_mandelbrot
ASM=bronzebeard --compress
DFU=python3 -m bronzebeard.dfu 28e9:0189


$(SOURCE).bin: $(SOURCE).asm 
	$(ASM)  $(SOURCE).asm -o $(SOURCE).bin
	
flash: $(SOURCE).bin
	$(DFU) $(SOURCE).bin

joystick: $(SOURCE_DEV).asm 
	$(ASM) $(SOURCE_DEV).asm -o $(SOURCE_DEV).bin
	$(DFU) $(SOURCE_DEV).bin
