;*********************************************
;	Boot1.asm
;		- A Simple Bootloader
;
;	Operating Systems Development Tutorial
;*********************************************
mov ah, 0x0e
mov bp, 0x8000
mov sp, bp

push 'A'
push 'B'
push 'C'

; Pop the stack and save the popped character in al
; We would *like* to just do "pop al", but we can't.
; 
; Remember we are in 16-bit mode so we can only pop
; 16 bits at a time, and al is an 8-bit register.
; 
; So we must pop into a 16-bit register such as ax, bx, etc.
; But we can't directly pop into ax either, as that risks overwriting
; ah, which should keep holding 0x0e.
; 
; So pop into another 16-bit register (randomly choose bx here),
; then move its lower byte to al.

pop bx
mov al, bl
int 0x10

pop bx
mov al, bl
int 0x10

; For the sake of exercise, try directly referencing the address of the
; last character.

; Where is the last character?
; Recall we set the stack base to be 0x8000
; The 'A' is represented as two bytes in 16-bit mode:
;   1) zero padding at 0x7fff
;   2) The actual character 'A' at 0x7ffe
; We want to put the actual charater into al.
mov al, [0x7ffe]
int 0x10
jmp $
; $: address of the current line
; $$: address of the first instruction. We set this at 0x7c00.
; $ - $$: the number of bytes from the current line to the start (aka size of the program)
; 
; The goal here is to zero-fill all unused bytes of the sector (512 bytes).
; On the boot sector we have:
; 1) The program itself
; 2) A bunch of padding zeros up to the 510th byte, leaving the last two bytes for:
; 3) The magic number that identifies the sector as a boot sector.

times 510 - ($ - $$) db 0
dw 0xAA55