; Aula 05 - Atividade 01
; arquivo: a05at01.asm
; objetivo: Conversão de duas letras para mauiúscula e minúscula com soma
; nasm -f elf64 a05at01.asm && ld a05at01.o -o a05at01.x && gdb ./a05at01.x

section .data
    maiuscula: db 'A'
    minuscula: db 'b'

    ; definindo uma variavel com o valor de 32 para somar ou subtrair,
        ; pois é essa a diferença entre letras maiúsculas e minúsculas em ASCII
    diferenca: db 32

section .bss
    lowercase: resb 1
    uppercase: resb 1

section .text
    global _start

_start:
    ; guardando os 8 bits do caracter nos registradores
    mov al, [maiuscula]
    mov bl, [minuscula]
    mov cl, [diferenca]

carregado:
    add al, cl
    sub bl, cl

    mov [lowercase], al
    mov [uppercase], bl

fim:
    mov rax, 60
    mov rdi, 0
    syscall
