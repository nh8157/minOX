[ORG 0x7c00]
KERNEL_OFFSET EQU 0x1000 	; Sets the starting address of kernel code

	MOV		[BOOT_DRIVE], DL	; Remember index to the boot drive
	MOV		BP, 0x8000			; Set base pointer and stack pointer
	MOV		SP, BP
	MOV		SI, BOOT_MSG		; Print booting message
	CALL	print_string_16

    MOV 	SI, SWITCH_MODE_MSG
    CALL 	print_string_16

	; Load kernel code into memory
	CALL	load_kernel

	; Switch to 32 bit protected mode
    CALL    switch_to_32

load_kernel:
	MOV		SI, LOAD_KERNEL_MSG 	;Print loading msg
	CALL	print_string_16

	MOV		BX, KERNEL_OFFSET		; Use the offset specified in compilation
	MOV		DH, 15				; Read 2 sectors from the drive (previous number was 15, too many)
	MOV		DL, [BOOT_DRIVE]		; Read from the drive BOOT_DRIVE
	CALL	disk_load
	RET

%include "print.asm"
%include "disk.asm"
%include "gdt.asm"
%include "switch_to_32.asm"

BOOT_DRIVE: 	DB 0x0
BOOT_MSG:		DB "minOX BOOTING IN 16-BIT MODE...", 0x0a, 0
LOAD_KERNEL_MSG:DB "LOADING KERNEL", 0x0a, 0
SWITCH_MODE_MSG:DB "SWITCHING TO 32-BIT MODE", 0x0a, 0

TIMES   510 - ($-$$) DB 0
DB      0x55,0xAA
