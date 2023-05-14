org 0
bits 16

jmp main

%include "print_string.asm"
main:
    cli
    push cs
    pop ds

    mov si, stage2Msg
    call print_string

    hlt
stage2Msg: db "decaf OS stage 2...", 13, 10, 0