; Aula 06 - Chamada de Sistemas
; arquivo: a06e01.asm
; objetivo: the evil papagali code!
; nasm -f elf64 a06e01.asm && ld a06e01.o -o a06e01.x && gdb ./a06e01.x

; uhm, macros de constantes? yep! nasm S2
%define maxChars 10

; estabelecendo variaveis definidas
section .data
    strOla : db "Hello?", 10, 0 ; 10 é a quebra de linha e 0 é o fim da string
    strOlaL: equ $ - strOla      ; cuidado: strOlaL "non-existe!" (equ) 

    strBye : db "Voce digitou: ", 0
    strByeL: equ $ - strBye 

    strLF  : db 10 ; quebra de linha ASCII!
    strLFL : dd 1

section .bss
    strLida  : resb maxChars
    strLidaL : resd 1

section .text
 	global _start

; NOTA: fd (file descriptor): 0 = entrada; 1 = saida tela; 2 = mensagem de erro

_start:
    ; escrita

    ; ssize_t write(int fd , const void *buf, size_t count);
    ; eax     write(int edi, const void *rsi, size_t edx  );
    ; quando tem * é ponteiro entao é ; lea reg, [var]
    mov rax, 1
    mov edi, 1  ; std_file
    lea rsi, [strOla]
    mov edx, strOlaL
    syscall

leitura:

    mov dword [strLidaL], maxChars ; %define é constantes!

    ; ssize_t read(int fd , const void *buf, size_t count);
    ; eax     read(int edi, const void *rsi, size_t edx  );

    mov rax, 0  ; READ
    mov edi, 0
    lea rsi, [strLida]
    mov edx, [strLidaL]
    syscall

    mov [strLidaL], eax

resposta:
    ; voce escreveu: 
    mov rax, 1  ; WRITE
    mov edi, 1
    lea rsi, [strBye]
    mov rdx, strByeL
    syscall

    ; palavea que escrevemos
    mov rax, 1  ; WRITE
    mov edi, 1
    lea rsi, [strLida]
    mov edx, [strLidaL]
    syscall

    ; quebra e fim de linha
    mov rax, 1  ; WRITE
    mov edi, 1
    lea rsi, [strLF]
    mov edx, [strLFL]
    syscall

fim:
    ; void _exit(int status);
    ; void _exit(int ebx   );
    mov rax, 60
    mov edi, 0
    syscall
