;*********************************************
;	Boot1.asm
;		- A Simple Bootloader
;
;	Operating Systems Development Tutorial
;*********************************************

; org = origin. Setting org to 0x7c00 puts this file at address 0x7c00,
; which, given this is a bootloader, is exactly where it should be.
org 0x7c00

; the "bits 16" directive tells NASM to generate code under 16-bit mode
; Why do this? For backward compatibility, all x86-compatible computers
; boot into 16-bit mode. Later on we'll switch to 32-bit mode.
bits 16

; cli: clear all interrupts
; hlt: halt the system
Start:
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
    cli
    hlt

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