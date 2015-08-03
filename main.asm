;  hello.asm  a first program for nasm for Linux, Intel, gcc
;
; assemble:   nasm -f elf -l hello.lst  hello.asm
; link:       gcc -o hello  hello.o
; or link:    ld -o hello hello.o
; run:        hello
; output is:  Hello World
; print(sum([int('1000001021'[int(i)])for i in sys.argv[1]])) - python

SECTION .data                       ; data section
msg: db  "1000001021"               ; the string to print, 10=cr
len: equ $-msg                      ; "$" means "here"
                                    ; len is a value, not an address
num3entered:                        ;
    db '0'                          ;
    times 24-$+num3entered db 0     ; total length is == 24 chars

SECTION .text                ; code section
global main                  ; make label available to linker
main:                        ; standard  gcc  entry point
    mov edx,len              ; arg3, length of string to print
    mov ecx,msg              ; arg2, pointer to string
    mov ebx,1                ; arg1, where to write, screen
    mov eax,4                ; write sysout command to int 80 hex
    int 0x80                 ; interrupt 80 hex, call kernel

; get data from output (stdin)
    mov ecx, [esp+4]            ; argc
    mov edx, [esp+8]            ; argv

; convert from string to int
    mov edx, num3entered            ; our string
    atoi:                           ;
        xor eax, eax                ; zero a "result so far"
        .top:                       ;
            movzx ecx, byte [edx]   ; get a character
            inc edx                 ; ready for next one
            cmp ecx, '0'            ; valid?
            jb .done                ;
                cmp ecx, '9'        ;
            ja .done                ;
            sub ecx, '0'            ; "convert" character to number
            imul eax, 10            ; multiply "result so far" by ten
            add eax, ecx            ; add in current digit
        jmp .top                    ; until done
    .done:
    ;ret


; finished
    mov ebx,0                ; exit code, 0=normal
    mov eax,1                ; exit command to kernel
    int 0x80                 ; interrupt 80 hex, call kernel
