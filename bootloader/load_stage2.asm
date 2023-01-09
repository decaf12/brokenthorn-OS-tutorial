load_stage2_loop:
    mov ax, word [cluster]
    pop bx
    call ClusterLBA

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
    jnz odd_cluster

even_cluster:
    and dx, 0x0fff
    jmp look_up_FAT

odd_cluster:
    shr dx, 4

look_up_FAT:
    mov word [cluster], dx
    cmp dx, 0x0ff0
    jb load_stage2_loop