[bits 16]
switch_to_32:
    ; Switch off interrupt
    CLI     
    ; Inform CPU the presence of GDT
    LGDT    [gdt_descriptor]
    ; Switch from 16 bit to 32 bit by modifying the first bit in control register
    MOV     EAX, CR0
    OR      EAX, 0x1
    MOV     CR0, EAX
    ; Issue a far jump to flush the pipeline and enter protective mode
    ; ?how does this qualify as a far jump?
    JMP     CODE_SEGMENT:init_32
    
[bits 32]
init_32:
    ; Redefine registers into 32 bit mode
    MOV     EBX, MSG_PM_BEGIN
    CALL    print_string_32
    MOV     AX, DATA_SEGMENT
    MOV     DS, AX
    MOV     ES, AX
    MOV     SS, AX
    MOV     FS, AX
    MOV     GS, AX

    ; Update stack to a new piece of free space in 32 bit
    MOV     EBP, 0x90000
    MOV     ESP, EBP

    CALL    BEGIN_PM

BEGIN_PM:
    MOV     EBX, MSG_PM_FIN
    CALL    print_string_32

	CALL	KERNEL_OFFSET
    JMP     $

MSG_PM_BEGIN:
    DB      "Landed in 32 bit mode", 0x0a, 0
MSG_PM_FIN:
    DB      "Protected mode initialization complete", 0x0a, 0
