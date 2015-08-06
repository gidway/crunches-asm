; compile: nasm -f elf32 -l main32.lst main32.asm
; linking: ld -melf_i386 -o main32 main32.o 
; running: ./main32

SECTION .data
m: db  1,0,0,0,0,0,1,0,2,1
;      0 1 2 3 4 5 6 7 8 9
c: db 0
n:	; buffor for number to print
	db '$'
	times 24-$+n db '$'

SECTION .text
global _start
_start:

	pop	eax		; Get the number of arguments
	pop	esi		; Get the program name
	mov	edi,[esp+eax*4]			;end of arguments
	pop	ecx		; Get the first actual argument ("foo")
	mov eax,0 	; wynik, ilosc brzuszkow
	mov ebx,0	; aktualna pozycja przetwarzanego lancucha
	.m:
		mov edx, 10 		; EDX ZAWIERA MNOZNIK DLA EAX (WYNIKU)
		mul edx 			; EAX = EAX*10 (PRZESUWA CYFRY W EAX O 1 W LEWO)
		mov dl, [esi+ebx]	; POBIERA DO DL KOLEJNY ZNAK LANCUCHA
		sub dl, '0' 		; ODEJMUJE OD DL (CYFRY) KOD ZNAKU '0'
		add eax, [m + edx] 	; DODAJE DO WYNIKU WLASNIE WYCIAGNIETA CYFRE
	; loop:for
	inc ecx
	cmp ecx,edi
	jb .m

	mov edi,n
	call liczbe_na_tekst

	mov edx,eax ; len
	mov ebx,1
	mov eax,4
	mov ecx,n
	int 0x80

;        mov edx,4              ; arg3, length of string to print
;    	mov ebx,1                ; arg1, where to write, screen
;    	mov eax,4                ; write sysout command to int 80 hex
;    	int 0x80                 ; interrupt 80 hex, call kernel

.finish:
    mov ebx,0                ; exit code, 0=normal
    mov eax,1                ; exit command to kernel
    int 0x80                 ; interrupt 80 hex, call kernelp


;PARAMETRY:
;EAX – LICZBA DO PRZEKONWERTOWANIA
;EDI – ADRES BUFORA NA LICZBE, POWINIEN BYC WYPELNIONY '$'
;ZWRACA:
;EAX – DLUGOSC LICZBY
liczbe_na_tekst:
;ZACHOWUJE WARTOSCI ZMIENIANYCH REJESTROW.
push ecx
push edx
push esi
mov ecx, 10 ;USTAWIA DZIELNIK
mov esi, 0 ;ESI BEDZIE INDEKSEM KOLEJNEJ CYFRY W CIAGU
.dziel:
mov edx, 0 ;ZERUJE EDX, PONIEWAZ PROCESOR BIERZE DZIELONA LICZBE Z EDX:EAX
div ecx ;DZIELI EAX (LICZBE DO PRZEKONWERTOWANIA) PRZEZ 10
add dl, '0' ;DODAJE DO RESZTY Z DZIELENIA KOD CYFRY '0'
mov [edi+esi], dl ;DODAJE KOLEJNA CYFRE DO CIAGU
inc esi ;WYBIERA NASTEPNE MIEJSCE W CIAGU
cmp eax, 1
jge .dziel ;POWTARZA PETLE JESLI EAX >= 1
push esi ;ESI ZAWIERA DLUGOSC LICZBY. ZACHOWUJEMY JA
;CYFRY W CIAGU MAJA ODWROCONA KOLEJNOSC
;TRZEBA JE PRZESTAWIC PIERWSZA Z OSTATNIA, DRUGA Z PRZEDOSTATNIA ITD
dec esi ;ESI WSKAZUJE NA KONIEC CIAGU
mov ecx, 0 ;ECX WSKAZUJE NA POCZATEK CIAGU
.odwroc:
mov al, [edi+ecx] ;AL = CYFRA Z POCZATKU
mov ah, [edi+esi] ;AH = CYFRA Z KONCA
mov [edi+ecx], ah ;WSTAWIA AH ZAMIAST AL W CIAGU
mov [edi+esi], al ;WSTAWIA AL NA MIEJSCU AH
inc ecx ;USTAWIA ECX I ESI NA KOLEJNE ZNAKI CIAGU
dec esi
cmp ecx, esi
jl .odwroc ;KONTYNUUJE PETLE DOPOKI EAX NIE ZROWNA SIE Z ESI
pop eax ;EAX = DLUGOSC LICZBY (DAWNE ESI)
;PRZYWRACA WARTOSCI REJESTROW
pop esi
pop edx
pop ecx
;WRACA DO MIEJSCA WYWOLANIA
ret
