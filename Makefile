# Linux makefile for cpmchars

cpmchars.com: cpmchars.asm
	z80asm -o cpmchars.com cpmchars.asm

clean:
	rm -f *.o *.com
