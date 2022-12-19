;*********************************************
;	Boot1.asm
;		- A Simple Bootloader
;
;	Operating Systems Development Tutorial
;*********************************************
mov ah, 0x0e
mov bx, 40

cmp bx, 4
jle print_A
jg check_B

print:
int 0x10
jmp $

print_A:
    mov al, 'A'
    jmp print

check_B:
    cmp bx, 40
    jl print_B
    jge print_C
print_B:
    mov al, 'B'
    jmp print
print_C:
    mov al, 'C'
    jmp print
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