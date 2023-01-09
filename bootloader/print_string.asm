print_string:
    mov ah, 0x0e
    loop:
        lodsb
        or al, al
        jz terminator_found
        int 0x10
        jmp loop

terminator_found:
    ret