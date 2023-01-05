org 0
bits 16
start: 
    jmp main

%include "print_string_redo.asm"
main:
    mov ax, cs
    mov ds, ax

    mov si, msg
    call print_string

    cli
    hlt

msg: db "decafOS stage 2"
times 510 - ($ - $$) db 0

dw 0xaa55