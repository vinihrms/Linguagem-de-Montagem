; Aula 06 - Aplicação sem sentido
; arquivo: a06e01.asm
; objetivo: Criar uma aplicação que leia o
;           próprio PID e execute a chamada kill

; nasm -f elf64 a06at01.asm && ld a06at01.o -o a06at01.x && gdb ./a06at01.x

%define maxChars 10 
; no. máximo de caracteres a serem lidos

%define createopenr  100o 
; flag open() - criar + leitura

section .data
    texto: db "esse programa veio cansado", 0 ; null-terminated string!


section .bss
    pid      : resb maxChars
    textoTamanho     : resd 1


section .text
    global _start

_start:
    mov rax, 39          ; get pid 
    syscall
    
    mov [pid], eax
pega:
    mov rax, 1   ; escrita em terminal
    mov edi, 1
    lea rsi, [texto]
    mov edx, [textoTamanho]
    syscall

escreve:
    mov rax, 62  ; kill
    mov edi, [pid]
    mov rsi, 9
    ;syscall

fecha:
    ; void _exit(int status);
    mov rax, 60
    mov edi, 0
    syscall
