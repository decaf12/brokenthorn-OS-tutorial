;*********************************************
;	Boot1.asm
;		- A Simple Bootloader
;
;	Operating Systems Development Tutorial
;*********************************************

; 0x10 is the interrupt for printing a to the screen
; parameters:
;   mode: stored in ah. Here we use 0x0e, which means tele-type mode
;   ASCII code: stored in al.
; 
; To print a whole string of characters, we leave ah at 0x0e, and repeatedly
; change al and call int 0x10.
mov ah, 0x0e
mov al, 'd'
int 0x10
mov al, 'e'
int 0x10
mov al, 'c'
int 0x10
mov al, 'a'
int 0x10
mov al, 'f'
int 0x10
mov al, 'O'
int 0x10
mov al, 'S'
int 0x10

; Jump to the current address, aka an infinite loop
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