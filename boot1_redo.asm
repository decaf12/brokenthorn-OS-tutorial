org 0
bits 16
start: 
    jmp main

%include "OEM_parameter_block.asm"
%include "print_string_redo.asm"
%include "LBACHS.asm"
%include "clusterToLBA.asm"
%include "readsectors.asm"    

main:
    cli
    ; Set all segment registers to 0x7c00
    mov ax, 0x07c0
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Create the stack
    xor ax, ax
    mov ss, ax
    mov sp, 0xFFFF
    sti

    mov si, blankLine
    call print_string

    mov si, loadingMsg
    call print_string

    %include "load_root_directory.asm"
    %include "find_stage_2_bootloader.asm"
    %include "load_FAT.asm"
    %include "load_stage_2_bootloader.asm"
    %include "stage_2_is_loaded.asm"
loadingStage2Msg: db ".", 0
stage2Name: db "DECAFOS2SYS"
stage2NotFoundMsg: db 0x0d, 0x0a, "Not found. Press any key to reboot.", 0x0d, 0x0a, 0x0d, 0x0a, 0
loadingMsg: db "Loading stage 2...", 0x0d, 0x0a, 0
blankLine: db 0x0d, 0x0a, 0
absoluteSector: db 0
absoluteHead: db 0
absoluteTrack: db 0

datasector: dw 0
cluster: dw 0
times 510 - ($ - $$) db 0

dw 0xaa55