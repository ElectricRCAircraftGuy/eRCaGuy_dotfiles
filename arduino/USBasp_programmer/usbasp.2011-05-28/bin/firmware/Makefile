MCU_TARGET     = atmega8
FLASHER        = avrdude -c usbasp -p $(MCU_TARGET)

usbasp: fuses
	$(FLASHER) -B 1 -U flash:w:usbasp.atmega8.2011-05-28.hex

fuses:
	$(FLASHER) -B 200 -U hfuse:w:0xC9:m -U lfuse:w:0xEF:m
shell:
	$(FLASHER) -t

