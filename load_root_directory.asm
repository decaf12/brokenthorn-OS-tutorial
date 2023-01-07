LOAD_ROOT:
    ; The goal is to call ReadSectors. Recall the registers we need:
    ;  ax: Sector location.
    ;  cx: Number of sectors to read
    ;  es:bx: buffer location

    xor cx, cx
    xor dx, dx

    ; Calculate number of sectors
    ; 32 byte per entry
    mov ax, 32
    ; Multiply by the entry count to get the total number of byes
    mul word [bpbRootEntries]

    ; Divide by the number of bytes per sector to get the sector count
    div word [bpbBytesPerSector]
    xchg ax, cx

    ; Calculate starting address
    mov al, byte [bpbNumberOfFATs]
    mul word [bpbSectorsPerFAT]
    add ax, word [bpbReservedSectors]

    add word [datasector], ax
    add word [datasector], cx

    ; Use 7C00:0200 as the buffer location. es is already set at 7C00 earlier on,
    ; so we only have to set bx here.
    mov bx, 0x0200
    
    call ReadSectors