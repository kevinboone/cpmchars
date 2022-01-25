;------------------------------------------------------------------------
;  CPMCHARS 
;
;  Dumps the 8-bit character set to the console, on a Z80-based CP/M
;  system. The first 32 characters are not dumped, nor is character 127,
;  which is typically a delete/rubout.
;
;  Copyright (c)2021 Kevin Boone, GPL v3.0
;------------------------------------------------------------------------

       ORG    0100H

       bdos: equ 0005H    ; define BDOS entry point
       bdos_conout: equ 2 ; Console output character

;------------------------------------------------------------------------
;  Start here 
;------------------------------------------------------------------------
main:
       ; Print the header
       LD     HL, header
       CALL   puts
       CALL   newline
       ; We will print 14 lines of 16 symbols
       LD     C, 14 
       LD     A, ' '    ; Start with char 20H, space 
main_next:
       ; doline prints each line, starting with the character in A
       CALL   doline
       DEC    C
       JP     Z, exit   ; When all done, exit

       JR     main_next ; Loop until 14 rows printed 

;------------------------------------------------------------------------
;  putch
;  Output the character in A; other registers preserved.
;------------------------------------------------------------------------
putch:
       PUSH   HL        ; We must preserve HL, as the BDOS call sets it
       PUSH   BC
       PUSH   AF
       PUSH   DE 
       LD     C, bdos_conout 
       LD     E, A 
       CALL   bdos 
       POP    DE
       POP    AF
       POP    BC
       POP    HL
       RET

;------------------------------------------------------------------------
;  putdigit
;  Output a single hex digit in A; other registers preserved 
;------------------------------------------------------------------------
putdigit:
       PUSH   AF
       CP     10        ; Digit >= 10
       JR     C, putdigit_lt
       ADD    A, 'A' - 10 
       CALL   putch
       POP    AF
       RET
putdigit_lt:            ; Digit < 10
       ADD    A, '0'
       CALL   putch
       POP    AF
       RET


;------------------------------------------------------------------------
;  putnum
;  Output the value in A as two-digit hex number; other reg. perserved
;------------------------------------------------------------------------
putnum:
       PUSH   AF
       SRA    A         ; Is there a nicer way to divide by 16?
       SRA    A
       SRA    A
       SRA    A
       AND    0x0F 
       CALL   putdigit
       POP    AF
       PUSH   AF
       AND    0x0F 
       CALL   putdigit
       POP    AF
       RET

;------------------------------------------------------------------------
; doline
; Write a line of 16 characters, preceded by the value in hex. The first
; value is in A. On exit, A has been incremented by 16; other registers
; are preserved.
;------------------------------------------------------------------------
doline:
       CALL   putnum
       PUSH   BC 
       CALL   space
       LD     C, 16     ; 16 characters on the line
doline_next:  
       CP     7FH    ; Skip the del/rubout character
       JR     Z, doline_nodel
       CALL   putch
doline_nodel:
       CALL   space
       INC    A
       DEC    C
       JR     NZ, doline_next ; Loop until all 16 done
       CALL   newline
       POP    BC 
       RET

;------------------------------------------------------------------------
;  newline
;  Output CR+LF; all registers preserved
;------------------------------------------------------------------------
newline:
       PUSH   AF
       LD     A, 13
       CALL   putch
       LD     A, 10
       CALL   putch
       POP    AF
       RET

;------------------------------------------------------------------------
;  space 
;  Output a space; all registers preserved
;------------------------------------------------------------------------
space:
       PUSH   AF
       LD     A,' ' 
       CALL   putch
       POP    AF
       RET

;------------------------------------------------------------------------
;  puts 
;  Output a zero-terminated string whose address is in HL; other
;  registers preserved.
;------------------------------------------------------------------------
puts:
       PUSH   AF
       PUSH   BC 
       PUSH   DE 
puts_next:
       LD     A,(HL) 
       OR     A, 0 
       JR     Z, puts_done

       LD     C, 2
       LD     E, A 
       PUSH   HL
       CALL   bdos 
       POP    HL

       INC    HL
       JR     puts_next
puts_done:
       POP    DE 
       POP    BC 
       POP    AF
       RET

;------------------------------------------------------------------------
; exit
; Return to BDOS
;------------------------------------------------------------------------
exit:
       LD C, 0
       CALL  bdos 

;------------------------------------------------------------------------
; Data 
;------------------------------------------------------------------------
header:
	defb "   0 1 2 3 4 5 6 7 8 9 A B C D E F"
        defb 0

