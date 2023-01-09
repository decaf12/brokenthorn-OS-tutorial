LBACHS:
    xor dx, dx
    div word [bpbSectorsPerTrack]
    inc dl
    mov byte [absoluteSector], dl

    xor dx, dx
    div word [bpbHeadsPerCylinder]
    mov byte [absoluteHead], dl
    mov byte [absoluteTrack], al

    ret