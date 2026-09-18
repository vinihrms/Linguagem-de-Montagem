; Aula 05 - Atividade 02
; arquivo: a05at02.asm
; objetivo: Conversão de duas letras para mauiúscula e minúscula lógicamente
; nasm -f elf64 a05at02.asm && ld a05at02.o -o a05at02.x && gdb ./a05at02.x

section .data
    maiuscula: db 'c'
    minuscula: db 'Z'

    ; para inverter o case da letra devemos inverter o 6o bit
        ; 00X0 0000
    altera: db 00100000b
section .bss
    lowercase: resb 1
    uppercase: resb 1

section .text
    global _start

_start:
    ; guardando os 8 bits do caracter nos registradores
    mov al, [maiuscula]
    mov bl, [minuscula]
    mov cl, [altera]

carregado:
    xor al, cl
    xor bl, cl

    mov [lowercase], al ; que agora é maiuscula e a outra minuscula. eu deixei o mesmo nome para mostrar que foi corrigido o que foi proposto na atv anterior
    mov [uppercase], bl

fim:
    mov rax, 60
    mov rdi, 0
    syscall
