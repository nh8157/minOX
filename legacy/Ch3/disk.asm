disk_load:
    PUSHA
    PUSH    DX
    MOV     AH, 0x02        ; Set to read mode
    MOV     AL, DH             ; Reads 1 sector from the disk
    MOV     CL, 0x02           ; Reads from the second sector of the front side (S)
    MOV     CH, 0x00           ; Reads from cylinder 0 (C)
    MOV     DH, 0x00           ; Reads from the first side of the disk (H)
    ; Somehow we don't need to set the drive number
    ; MOV     DL, 0x01           ; Reads from drive 0
    ; Because BIOS automatically stores the boot drive in DL
    INT     0x13
    JC      disk_error
    ; Validate if the read was successful
    POP     DX
    CMP     DH, AL
    JNE     sector_error
    POPA
    RET

disk_error:
    MOV     SI, disk_error_msg
    CALL    print_string
    JMP     $

sector_error:
    MOV     SI, sector_error_msg
    CALL    print_string
    JMP     $

disk_error_msg:
    DB      'Error occurred while reading the disk', 0x0a, 0

sector_error_msg:
    DB      'Error reading disk sector', 0x0a, 0