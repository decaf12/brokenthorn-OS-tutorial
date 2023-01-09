ClusterLBA:
    sub ax, 2
    xor cx, cx
    mov cl, byte [bpbSectorsPerCluster]
    mul cx
    add ax, word [datasector]
    ret