org 0
bits 16
start: 
    jmp main

%include "print_string_redo.asm"
main:
    push cs
    pop ds

    mov si, msg
    call print_string

    cli
    hlt

msg: db "decafOS stage 2", 0x0d, 0x0a, 0