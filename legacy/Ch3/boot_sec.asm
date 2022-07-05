[ORG 0x7c00]

entry:
    MOV     BP, 0x8000
    MOV     SP, BP
    ; MOV     BX, 0x07c0      ; Set DS register to the address this program is loaded
    ; MOV     DS, BX          ; Achieve the same effect as setting ORG
    MOV     SI, boot_msg
    CALL    print_string
    ; Setup address into which the data is read
    ; By adding the offset and the relative address, the data will be read into 0x8200
    MOV     AX, 0
    MOV     ES, AX
    MOV     BX, 0x9000        ; Read from address 0x9000 + 0x00000
    ; Set the number of sectors to read
    MOV     DH, 0x01
    CALL    disk_load

    MOV     DX, [0x9000]
    CALL    print_hex

    JMP     loop

loop:
    JMP loop

boot_msg:
    DB      'OS BOOTING UP...', 0x0a, 0

%include "print.asm"
%include "disk.asm"

TIMES   510 - ($-$$) DB 0

DB      0x55,0xAA

TIMES 256 DW 0xdada ; sector 2 = 512 bytes
TIMES 256 DW 0xface ; sector 3 = 512 bytes