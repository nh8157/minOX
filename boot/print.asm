[bits 16]

print_string_16:          ; Prints a string at the address stored in register SI 
    PUSHA
    MOV     AH, 0x0e

print_string_iter_16:
    MOV     AL, [SI]
    CMP     AL, 0
    JE      print_string_fin_16
    INT     0x10
    ADD     SI, 1
    JMP     print_string_iter_16

print_hex:
; Integer data is stored in register DX
    MOV     CX, 0   ; Counter that tracks the number of bits covered
    MOV     SI, default_hex

print_hex_iter:
    MOV     AX, DX  ; Copy numeric data from register DX
    SHL     CX, 2
    SHR     AX, CL  ; Shift the value in AX right by CX bits
    SHR     CX, 2
    AND     AX, 0x0F
    CALL    interpret_hex   ; Final result returned in AL
    MOV     BX, 5
    SUB     BX, CX
    ADD     BX, default_hex
    MOV     [BX], AL
    ADD     CX, 1
    CMP     CX, 4
    JAE     print_string_16
    JMP     print_hex_iter

default_hex:
    DB      '0x0000', 0

interpret_hex:
    CMP     AL, 9
    JG      above_9
    JMP     below_9

below_9:
    ADD     AL, 48          ; when it can be represented using a number
    RET                     ; convert it to ACSII number that reprensents it

above_9:
    ADD     AL, 87
    RET

print_string_fin_16:
    POPA
    RET

[bits 32]

VIDEO_MEMORY    EQU     0xb8000
WHITE_ON_BLACK  EQU     0x0f

print_string_32:
    PUSHA
    MOV     EDX, VIDEO_MEMORY

print_string_32_iter:
    MOV     AL, [EBX]
    MOV     AH, WHITE_ON_BLACK

    CMP     AL, 0
    JE      print_string_fin_32

    MOV     [EDX], AX

    ADD     EDX, 2
    ADD     EBX, 1

    JMP     print_string_32_iter

print_string_fin_32:
    POPA
    RET
