; compile:
; 	nasm -f elf32 -l v3.lst v3.asm
;	ld -melf_i386 -o v3 v3.o
;
; testing:
;	./v3 891 echo -e "\nresult=$?\n"
;
; Application return result by error code... yes, i know - it is ugly ;)

SECTION .data
	tab: db 1,0,0,0,0,0,1,0,2,1
	;		0 1 2 3 4 5 6 7 8 9

SECTION .text
global _start
_start:
	
	times 3 pop esi ; get: argc, argv[0], argv[1]

	push ebp
	mov ebp, esp
	sub esp, 2

	mov dword [ebp - 0], 0x0000 ; used only 1 byte. it is a little problem
	mov dword [ebp - 1], 0x0000 ; used only 1 byte

	dofor: ; # 01, for:begin
		; # 01, for[rules]:begin
		xor eax, eax
		mov al, [esi]
		inc esi
		cmp al, 0
		jz endfor
		; # 01, for[rules]:end

		sub al, 48 ; convert from ascii to integer
		mov byte [ebp - 1],  al ; .ichar, tmp variable

		; ----
		push esi
		push eax

		mov esi, tab
		mov ebx, dword [ebp - 1]
		xor eax, eax
		mov al, byte [esi+ebx*1]
		add byte [ebp - 0], al

		pop eax
		pop esi
		; ----

	jmp dofor ; # 01, for:end
	endfor:

	mov ebx, dword [ebp - 0]
	mov esp, ebp
	pop ebp

	; quit from application
	mov eax, 1
	int 0x80
; eof
