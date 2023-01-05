org 0x7c00
bits 16
start: 
    jmp main

times 0x0b - $ + start db 0

bpbBytesPerSector:  	dw 512
bpbSectorsPerCluster: 	db 1
bpbReservedSectors: 	dw 1
bpbNumberOfFATs: 	    db 2
bpbRootEntries: 	    dw 224
bpbTotalSectors: 	    dw 2880
bpbMedia: 	            db 0xf0
bpbSectorsPerFAT: 	    dw 9
bpbSectorsPerTrack: 	dw 18
bpbHeadsPerCylinder: 	dw 2
bpbHiddenSectors: 	    dd 0
bpbTotalSectorsBig:     dd 0
bsDriveNumber: 	        db 0
bsUnused: 	            db 0
bsExtBootSignature: 	db 0x29
bsSerialNumber:	        dd 0xa0a1a2a3
bsVolumeLabel: 	        db "MOS FLOPPY "
bsFileSystem: 	        db "FAT12   "

%include "print_string_redo.asm"
main:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov si, msg
    call print_string

    xor ax, ax
    int 0x12
    cli
    hlt

msg: db "decafOS stage 1"
times 510 - ($ - $$) db 0

dw 0xaa55