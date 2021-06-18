# cpmchars

Version 0.1, Kevin Boone, June 2021

## What is this?

`cpmchars` is a trivially simple utility that dumps the character
values from 32 (space) to 255 to the console via a BDOS call.
I wrote it to check that my terminal was handling 8-bit characters
correctly (of course, "correctly" is a vague term in what is,
essentially, an ASCII operating system). At 192 bytes, it's actually
smaller than a text file containing the characters -- and there's
no guarantee that if you `TYPE` a file with 8-bit characters, the
`TYPE` command won't strip off the top bit.

## Installation

Copy `cpmchars.com` to any CP/M drive.

## Running

Just run `cpmchars` at the prompt.

## Notes

CP/M is essentially an ASCII system. Some CP/M programs use 8-bit 
characters, but they would have been intended for some specific terminal
or display device.
It's quite common for CP/M programs to output box-drawing characters
from the CP437 (MSDOS) character set although, so far as I'm aware,
no terminal that was routinely used with CP/M supported this character
set. The VT52, for example, had a completely proprietary set of
characters with values 128 and above, and only 32 of those were used.

It is therefore not "wrong" if your monitor/terminal does not display
the expected values for 8-bit characters. However, it's often necessary
to tweak monitor or terminal settings, to get useful results with
CP/M programs that use these characters.

It's a long time since I wrote Z80 code for a living, and I suspect that
a skilled assembler programmer could do the same job in about ten
lines of code.



