org 0x7c00
bits 16
start: jmp loader
msg	db	"decafOS", 0

;*************************************************;
;	OEM Parameter block
;*************************************************;

; Error Fix 2 - Removing the ugly TIMES directive -------------------------------------

;;	TIMES 0Bh-$+start DB 0					; The OEM Parameter Block is exactally 3 bytes
								; from where we are loaded at. This fills in those
								; 3 bytes, along with 8 more. Why?

bpbOEM			db "My OS   "				; This member must be exactally 8 bytes. It is just
								; the name of your OS :) Everything else remains the same.

bpbBytesPerSector:  	DW 512
bpbSectorsPerCluster: 	DB 1
bpbReservedSectors: 	DW 1
bpbNumberOfFATs: 	    DB 2
bpbRootEntries: 	    DW 224
bpbTotalSectors: 	    DW 2880
bpbMedia: 	            DB 0xF0
bpbSectorsPerFAT: 	    DW 9
bpbSectorsPerTrack: 	DW 18
bpbHeadsPerCylinder: 	DW 2
bpbHiddenSectors: 	    DD 0
bpbTotalSectorsBig:     DD 0
bsDriveNumber: 	        DB 0
bsUnused: 	            DB 0
bsExtBootSignature: 	DB 0x29
bsSerialNumber:	        DD 0xa0a1a2a3
bsVolumeLabel: 	        DB "MOS FLOPPY "
bsFileSystem: 	        DB "FAT12   "

;***************************************
;	Prints a string
;	DS=>SI: 0 terminated string
;***************************************

Print:
			lodsb
			or			al, al				; al=current character
			jz			PrintDone			; null terminator found
			mov			ah,	0eh			; get next character
			int			10h
			jmp			Print
PrintDone:
			ret

;*************************************************;
;	Bootloader Entry Point
;*************************************************;

loader:

; Error Fix 1 ------------------------------------------

	xor	ax, ax		; Setup segments to insure they are 0. Remember that
	mov	ds, ax		; we have ORG 0x7c00. This means all addresses are based
	mov	es, ax		; from 0x7c00:0. Because the data segments are within the same
				; code segment, null em.

	mov	si, msg
	call	Print

	xor	ax, ax						; clear ax
	int	0x12						; get the amount of KB from the BIOS

	cli			; Clear all Interrupts
	hlt			; halt the system


LOAD_ROOT:
     
     ; compute size of root directory and store in "cx"
     
          xor     cx, cx
          xor     dx, dx
          mov     ax, 0x0020                      ; 32 byte directory entry
          mul     WORD [bpbRootEntries]           ; total size of directory
          div     WORD [bpbBytesPerSector]        ; sectors used by directory
          xchg    ax, cx
          
     ; compute location of root directory and store in "ax"
     
          mov     al, BYTE [bpbNumberOfFATs]       ; number of FATs
          mul     WORD [bpbSectorsPerFAT]          ; sectors used by FATs
          add     ax, WORD [bpbReservedSectors]    ; adjust for bootsector
          mov     WORD [datasector], ax            ; base of root directory
          add     WORD [datasector], cx
          
     ; read root directory into memory (7C00:0200)
     
          mov     bx, 0x0200                        ; copy root dir above bootcode
          call    ReadSectors

LOAD_FAT:
     
     ; save starting cluster of boot image
     
          mov     si, msgCRLF
          call    Print
          mov     dx, WORD [di + 0x001A]
          mov     WORD [cluster], dx                  ; file's first cluster
          
     ; compute size of FAT and store in "cx"
     
          xor     ax, ax
          mov     al, BYTE [bpbNumberOfFATs]                ; number of FATs
          mul     WORD [bpbSectorsPerFAT]                ; sectors used by FATs
          mov     cx, ax
 
     ; compute location of FAT and store in "ax"
 
          mov     ax, WORD [bpbReservedSectors]          ; adjust for bootsector
          
     ; read FAT into memory (7C00:0200)
 
          mov     bx, 0x0200                          ; copy FAT above bootcode
          call    ReadSectors
times 510 - ($-$$) db 0		; We have to be 512 bytes. Clear the rest of the bytes with 0

dw 0xAA55			; Boot Signiture