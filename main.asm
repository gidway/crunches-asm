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
    times 99-$+num3entered db 0     ; total length is == 24 chars

SECTION .text                ; code section
global main                  ; make label available to linker
main:                        ; standard  gcc  entry point
    mov edx,len              ; arg3, length of string to print
    mov ecx,msg              ; arg2, pointer to string
    mov ebx,1                ; arg1, where to write, screen
    mov eax,4                ; write sysout command to int 80 hex
    int 0x80                 ; interrupt 80 hex, call kernel

; get data from output (stdin)
%ifdef X84_64
    ; x86_64, 64b
    ;mov rcx, rdi        ; argc - check number of arguments on argv
    mov r8, 8           ; offset to second arg - if not exist we have problem
    arg64:
        mov rdx, qword [rsi+r8]     ; argv
        push rcx                    ; save registers that printf wastes
        push rdx
        push rsi
        push r8
        mov rdi, format     ; first parameter for printf
        mov rsi, rdx        ; second parameter for printf
        mov rax, 0          ; no floating point register used
        call printf         ; call to printf
        pop r8              ; restore registers
        pop rsi
        pop rdx
        pop rcx
        add r8, 8           ; point to next argument
        dec rcx             ; count down
    jnz arg64               ; if not done counting keep going

%else
    ; x386, 32b
    mov ecx, [esp+4]        ; argc
    mov edx, [esp+8]        ; argv
    arg32:                  ;
        push ecx            ; save registers that printf wastes
        push edx            ;
        push dword [edx]    ; the argument string to display
        push format         ; the format string
        call printf         ;
        add esp, 8          ; remove the two parameters
        pop edx             ; restore registers printf used
        pop ecx             ;
        add edx, 4          ; point to next argument
        dec ecx             ; count down
    jnz arg32               ; if not done counting keep going

%endif

; convert from string to int
    mov edx, num3entered            ; our string
    atoi:                           ;
        xor eax, eax                ; zero a "result so far"
        .top:                       ;
            movzx ecx, byte [edx]   ; get a character
            inc edx                 ; ready for next one
            cmp ecx, '0'            ; valid?
                jb .done            ;
            cmp ecx, '9'            ;
                ja .done            ;
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
