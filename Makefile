# Linux makefile for cpmchars

cpmchars.com: cpmchars.asm
	z80asm -b cpmchars.asm
	mv cpmchars.bin cpmchars.com

clean:
	rm -f *.o *.com
