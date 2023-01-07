FIND_STAGE2:
    mov cx, word [bpbRootEntries]
    mov di, 0x0200

    linearSearch:
        push cx
        mov cx, 11
        mov si, stage2Name
        push di
        rep cmpsb
        pop di
        je LOAD_FAT

        pop cx
        add di, 32
        loop linearSearch
        jmp notFound

    notFound:
        mov si, stage2NotFoundMsg
        call print_string

        xor ax, ax
        int 0x16
        int 0x19