; Defines the global descriptor table
gdt_start:

; Null descriptor that handles exception
gdt_null:
    ; TIMES 8 DB 0x00
    DD 0x0
    DD 0x0

; Segment descriptor for code region
gdt_code:
    ; Bit 0-15 (Seg limit)
    DW 0xffff
    ; Bit 16-31 (Base addr)
    DW 0x0
    ; Bit 32-39 (Base addr)
    DB 0x0
    ; Bit 40-47
    DB 10011010b
    ; Bit 48-55
    DB 11001111b
    ; Bit 56-63 (Base addr)
    DB 0x0

gdt_data:
    DW 0xffff
    DW 0x0
    DB 0x0
    DB 10010010b
    DB 11001111b
    DB 0x0

gdt_end:

gdt_descriptor:
    DW gdt_end - gdt_start - 1  ; size of the gdt table (always one less)
    DD gdt_start                ; define the starting address of the gdt_table

CODE_SEGMENT EQU gdt_code - gdt_start
DATA_SEGMENT EQU gdt_data - gdt_start
