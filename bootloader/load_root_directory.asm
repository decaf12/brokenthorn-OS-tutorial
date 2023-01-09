mov ax, 32
mul word [bpbRootEntries]
div word [bpbBytesPerSector]
mov cx, ax

mov al, byte [bpbNumberOfFATs]
mul word [bpbSectorsPerFAT]
add ax, word [bpbReservedSectors]

add word [datasector], ax
add word [datasector], cx

mov bx, 0x0200
call ReadSectors