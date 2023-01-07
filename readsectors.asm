ReadSectors:
    mainLoop:
        mov dl, 5

        sectorLoop:
            push ax
            push bx
            push cx
            
            ; After we call LBACHS, we'll have the CHS address
            ; ready in [absoluteSector], [absoluteHead], and
            ; [absoluteTrack]
            call LBACHS

            ; Call int 0x13 to read a sector
            ; ah: Function mode. Set to 0x02 for reading a sector.
            ; al: Number of sectors to read. Set to 0x01 because we are only reading one at a time.
            ; ch: Lower eight bits of the cylinder number. For our purposes this is just the entire
            ;     cylinder number. Set to [absoluteTrack]
            ; cl: Absolute sector number. Set to [absoluteSector]
            ; dh: Head number. Set to [absoluteHead]
            ; dl: Drive number. Set to [bsDriveNumber]

            mov ah, 2
            mov al, 1
            mov ch, byte [absoluteTrack]
            mov cl, byte [absoluteSector]
            mov dh, byte [absoluteHead]
            mov dl, byte [bsDriveNumber]
            int 0x13

            jnc readSuccess
        
            ; Read failed. Call int 0x13 to reset the disk
            ; ah: Function number. Set to 0 for disk reset.
            xor ax, ax
            int 0x13

            ; One fewer tries left
            dec di
            
            pop cx
            pop bx
            pop ax

            ; If there are still tries left, retry.
            jnz sectorLoop

            ; Otherwise call int 0x18 to warm reboot.
            int 0x18

        readSuccess:
            mov si, loadingStage2Msg
            call print_string
            pop cx
            pop bx
            pop ax
            add bx, word [bpbBytesPerSector]
            inc ax
            loop mainLoop
            ret