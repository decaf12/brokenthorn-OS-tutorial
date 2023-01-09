org 0
bits 16
start:
    jmp main

%include "OEM_parameter_block.asm"
%include "print_string.asm"
%include "LBACHS.asm"
%include "read_sectors.asm"
%include "ClusterLBA.asm"

main:
    cli
    %include "set_segments.asm"
    %include "create_stack.asm"
    sti

    mov si, blankLine
    call print_string

    mov si, stage1LoadingMsg
    call print_string

    %include "load_root_directory.asm"
    %include "find_stage2.asm"
    %include "load_FAT.asm"
    %include "load_stage2.asm"
    %include "stage2_is_loaded.asm"

stage2Name: db "DECAFOS SYS"
stage2NotFoundMsg: db "Stage 2 not found. Press any key to restart.", 13, 10, 0
stage1LoadingMsg: db "decafOS stage 1", 13, 10, 0
blankLine: db 13, 10, 0
sectorReadSuccessMsg: db ".", 0

absoluteSector: db 0
absoluteHead: db 0
absoluteTrack: db 0
datasector: dw 0
cluster: dw 0
times 510 - ($ - $$) db 0
dw 0xaa55