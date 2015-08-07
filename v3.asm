SECTION .data
	num: db "728",0,'$'
	len: equ $-num
	tab: db 1,0,0,0,0,0,1,0,2,1
	;		0 1 2 3 4 5 6 7 8 9
%ifdef GCCMAIN
	msg1: db "debug: %d\n",0
%endif

SECTION .text
%ifdef GCCMAIN
extern printf
global main
main:
%else
global _start
_start:
%endif

%ifndef GCCMAIN
	pop ebx		; argc
	pop ebx		; arv[0] name of app
	pop ebx		; argc[1], our args
%endif

	push ebp
	mov ebp,esp
	sub esp,10	; local variable: .result{offset:4}, .ichar{offset:2}

	mov esi,num
	;mov esi,ebx
	mov dword [ebp - 4],0		; .result := 0
	mov dword [ebp - 8],0		; .ichar := 0

	zapierdalaj:
		mov eax,[esi]
		inc esi
		cmp eax,0		; looking for end of string
		je finished

		sub eax,'0'
		mov dword [ebp - 8], eax 	; .ichar

		push esi
		push ebp
		push eax
		; -----------
		mov esi, tab
		mov ebx, dword [ebp - 8] ; second param is a number, read .ichar
		mov eax, [esi+ebx*4]	; val
		add dword [ebp - 4], eax	; .result + val
		; -----------
		pop eax
		pop ebp
		pop esi

		%ifdef GCCMAIN
			push dword [ebp - 4]
			push dword msg1
			call printf
		%endif

	jmp zapierdalaj

finished:
    mov ebx, dword [ebp - 4]		; return .result
	mov esp, ebp
	pop ebp
;%ifdef GCCMAIN
	ret
;%else
    mov eax,1                ; exit command to kernel
    int 0x80                 ; interrupt 80 hex, call kernel
;%endif
