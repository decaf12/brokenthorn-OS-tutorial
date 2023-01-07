STAGE_2_LOADED:
    mov si, blankLine
    call print_string

    push word 0x0050
    push word 0
    retf