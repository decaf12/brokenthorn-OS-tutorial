org 0x7c00
bits 16
start: jmp loader
msg	db	"decafOS", 0

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

	cli			; Clear all Interrupts
	hlt			; halt the system
	
times 510 - ($-$$) db 0		; We have to be 512 bytes. Clear the rest of the bytes with 0

dw 0xAA55			; Boot Signiture