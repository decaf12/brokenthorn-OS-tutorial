ReadSectors:
    main_loop:
        mov di, 5
    
    sector_loop:
        push ax
        push bx
        push cx

        call LBACHS

        mov ah, 2
        mov al, 1
        mov ch, byte [absoluteTrack]
        mov cl, byte [absoluteSector]
        mov dh, byte [absoluteHead]
        mov dl, byte [bsDriveNumber]
        int 0x13
        jnc sector_successfully_read
        xor ax, ax
        int 0x13
        dec di
        pop cx
        pop bx
        pop ax
        jnz sector_loop
        int 0x18
    
    sector_successfully_read:
        mov si, sectorReadSuccessMsg
        call print_string
        pop cx
        pop bx
        pop ax
        add bx, word [bpbBytesPerSector]
        inc ax
        loop main_loop
        ret