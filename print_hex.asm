print_hex:
    pusha
    mov ah, 0x0e
    mov bx, HEX_OUT + 5
    loop:
        cmp bx, HEX_OUT + 1
        je post_modification

        mov [bx], dl
        and [bx], byte 0xf
        cmp [bx], byte 10
        jl put_numeric
        jge put_letter
        return_to_loop:
            shr dx, 4
            dec bx
            jmp loop
    popa
    ret

put_numeric:
    add [bx], byte '0'
    jmp return_to_loop
put_letter:
    add [bx], byte 'a' - 10
    jmp return_to_loop

post_modification:
    mov bx, HEX_OUT ; print the string pointed to
    call print_string ; by BX
    popa
    ret

HEX_OUT:
    db '0x0000', 0