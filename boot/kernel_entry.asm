[bits 32]
[extern main]	; Declare that we are using an external function main
CALL main		; Invoke function main
JMP	$			; Return here when main finishes execution
