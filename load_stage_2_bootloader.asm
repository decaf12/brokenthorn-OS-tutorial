LOAD_STAGE2:
        mov ax, word [cluster]
        pop bx
        
        call clusterToLBA
        xor cx, cx
        mov cl, byte [bpbSectorsPerCluster]
        call ReadSectors

        push bx

        mov ax, word [cluster]
        mov cx, ax
        mov dx, ax

        shr dx, 1
        add cx, dx
        add bx, cx
        add bx, 0x0200

        mov dx, word [bx]

        test ax, 1
        jnz oddCluster

    evenCluster:
        and dx, 0x0fff
        jmp lookUpNextCluster

    oddCluster:
        shr dx, 4

    lookUpNextCluster:
        mov word [cluster], dx
        cmp dx, 0x0ff0
        jb LOAD_STAGE2