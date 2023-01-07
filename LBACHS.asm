LBACHS:
    ; Goal: fill out the following:
    ; [absoluteSector]
    ; [absoluteHead]
    ; [absoluteTrack]

    ; Calculate absolute sector number
    xor dx, dx
    div word [bpbSectorsPerTrack]
    inc dl
    mov byte [absoluteSector], dl

    ; Calculate absolute head and track number
    xor dx, dx
    div word [bpbHeadsPerCylinder]
    mov byte [absoluteHead], dl
    mov byte [absoluteTrack], al
    ret