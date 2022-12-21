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