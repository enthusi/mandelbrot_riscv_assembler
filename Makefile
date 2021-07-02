SOURCE=mandelbrot
ASM=bronzebeard --compress
DFU=python3 -m bronzebeard.dfu 28e9:0189

$(SOURCE).bin: $(SOURCE).asm 
	$(ASM)  $(SOURCE).asm -o $(SOURCE).bin

flash: $(SOURCE).bin
	$(DFU) $(SOURCE).bin
