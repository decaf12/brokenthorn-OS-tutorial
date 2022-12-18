;*********************************************
;	Boot1.asm
;		- A Simple Bootloader
;
;	Operating Systems Development Tutorial
;*********************************************

loop:
    jmp loop

times 510 - ($ - $$) db 0
dw 0xAA55