LOAD_FAT:
    mov si, blankLine
    call print_string

    mov dx, word [di + 26]
    mov word [cluster], dx

    xor ax, ax
    mov al, byte [bpbNumberOfFATs]
    mul word [bpbSectorsPerFAT]
    mov cx, ax

    mov ax, word [bpbReservedSectors]

    mov bx, 0x0200
    call ReadSectors

    mov si, blankLine
    call print_string

    mov ax, 0x0050
    mov es, ax
    xor bx, bx

    push bx