print_string:
    pusha
    mov ah, 0x0e
    loop:
        lodsb
        or al, al
        jz end_print_string
        int 0x10
        jmp loop

end_print_string:
    popa
    ret