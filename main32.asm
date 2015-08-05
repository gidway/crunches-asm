; compile: nasm -f elf32 -l main32.lst main32.asm
; linking: ld -melf_i386 -o main32 main32.o 
; running: ./main32

SECTION .data
m: db  1,0,0,0,0,0,1,0,2,1
;      0 1 2 3 4 5 6 7 8 9
c: db 0

SECTION .text
global _start
_start:

	pop	eax		; Get the number of arguments
	pop	esi		; Get the program name
	mov	edi,[esp+eax*4]			;end of arguments
	pop	ecx		; Get the first actual argument ("foo")
	.m:
        mov eax,[ecx]
        sub eax,'0' ; convert to ascii
		mov ebx,m
        add ebx,eax
        mov edx,[ebx]
        mov ebx,[c]
        add ebx,[edx]
        mov [c],ebx
	inc ecx
	cmp ecx,edi
	jb .m

	mov edx,1 ; len
	mov ebx,1
	mov eax,4
	mov ecx,'A'
	int 0x80

;        mov edx,4              ; arg3, length of string to print
;    	mov ebx,1                ; arg1, where to write, screen
;    	mov eax,4                ; write sysout command to int 80 hex
;    	int 0x80                 ; interrupt 80 hex, call kernel

.finish:
    mov ebx,0                ; exit code, 0=normal
    mov eax,1                ; exit command to kernel
    int 0x80                 ; interrupt 80 hex, call kernelp
