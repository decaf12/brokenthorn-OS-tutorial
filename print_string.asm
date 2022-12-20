print_string:
    pusha
    mov ah, 0x0e
print_string_loop:
    mov al, [bx]
    cmp al, 0
    je end_string
    int 0x10
    inc bx
    jmp print_string_loop
end_string:
    popa
    ret

print_hex:
    pusha
    mov ah, 0x0e
    mov bx, HEX_OUT + 5
    loop:
        cmp bx, HEX_OUT + 1
        je post_modification

        mov cx, dx
        and cl, byte 0x0f
        cmp cl, byte 10
        jl put_numeric
        jge put_letter
        return_to_loop:
            mov [bx], cl     
            shr dx, 4
            dec bx
            jmp loop
    popa
    ret

put_numeric:
    add cl, byte '0'
    jmp return_to_loop
put_letter:
    add cl, byte 'a' - 10
    jmp return_to_loop

post_modification:
    ; TODO : manipulate chars at HEX_OUT to reflect DX
    mov bx, HEX_OUT ; print the string pointed to
    call print_string ; by BX
    popa
    ret

HEX_OUT:
    db '0x0000', 0