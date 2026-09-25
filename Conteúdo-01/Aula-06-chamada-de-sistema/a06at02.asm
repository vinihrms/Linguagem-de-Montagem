; Aula 06 - Papagali Persistente
; arquivo: a06at02.asm
; objetivo: 
    ; A cada execução, o texto entrado pelo usuário deve ser escrito ao final de um arquivo
    ; Caso o arquivo não exista, deve ser criado com o nome “papagali.txt”
    ; Caso exista, o texto deve ser adicionado ao final (append)

; nasm -f elf64 a06at02.asm && ld a06at02.o -o a06at02.x && gdb ./a06at02.x

; uhm, macros de constantes? yep! nasm S2
%define maxChars 10

; estabelecendo variaveis definidas
section .data
    strOla : db "Hello?", 10, 0 ; 10 é a quebra de linha e 0 é o fim da string
    strOlaL: equ $ - strOla      ; cuidado: strOlaL "non-existe!" (equ) 

    strArquivo: db "papagali.txt", 0
    srtArquivo: equ $ - strArquivo

    strBye : db "Voce digitou: ", 0
    strByeL: equ $ - strBye 

    strLF  : db 10 ; quebra de linha ASCII!
    strLFL : dd 1

section .bss
    strLida  : resb maxChars
    strLidaL : resd 1
    fd: resd 1

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

escrita:
    ; abertura
    mov rax, 2
    lea edi, [strArquivo]
    mov esi, 2101o
    mov edx, 644o
    syscall

    mov [fd], eax ; guardo descritor do arquivo

    ; escrevendo no arquivo
    mov rax, 1
    mov edi, [fd]
    lea esi, [strLida]
    mov edx, [strLidaL]
    syscall

    mov rax, 3
    mov edi, [fd]
    syscall


fim:
    ; void _exit(int status);
    ; void _exit(int ebx   );
    mov rax, 60
    mov edi, 0
    syscall
