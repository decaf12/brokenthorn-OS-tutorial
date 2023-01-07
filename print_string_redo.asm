print_string:
    pusha
    loop:
        lodsb
        or al, al
        jz end_print_string
        mov ah, 0x0e
        int 0x10
        jmp loop

end_print_string:
    popa
    ret