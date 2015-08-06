; v2.asm
;

SECTION .data
	numin: db "745",0		; cyfra do przerobienia
	len: equ $-numin
	tab: db 1,0,0,0,0,0,1,0,2,1

SECTION .text
global _start
_start:

	mov esi,numin
	mov edi,len
	xor esi,esi
	xor ebx,ebx

	loop1:

		xor eax,eax
		mov al,byte[numin+esi]

		cmp al,0		; end of string
		je finished

		sub al,'0'

		inc esi
		;cmp esi,3
		;jmp loop1

		;add ebx,[tab+eax]
		cmp al,0
		je addOne
		cmp al,6
		je addOne
		cmp al,9
		je addOne

		jmp loop1
	
finished:
    ;mov ebx,eax                ; exit code, 0=normal
    mov eax,1                ; exit command to kernel
    int 0x80                 ; interrupt 80 hex, call kernel

addOne:
	inc ebx
	jmp loop1

addTwo:
	add ebx,2
	jmp loop1

; eof
