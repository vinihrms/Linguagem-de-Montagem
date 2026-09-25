; Aula 05 - Atividade 03
; arquivo: a05at03.asm
; objetivo: soma de elementos de um vetor
; nasm -f elf64 a05at03.asm && ld a05at03.o -o a05at03.x && gdb ./a05at03.x

section .data
    triangularNum: dd 0, 1, 3, 6, 10, 15, 21, 28

section .bss
    somatorio: resd 1

section .text
    global _start

_start:
    mov ebx, 0d

    mov eax, [triangularNum + 0 * 4] ; triangularNum[0]
    add ebx, eax

    mov eax, [triangularNum + 1 * 4] ; triangularNum[1]
    add ebx, eax

    mov eax, [triangularNum + 2 * 4] ; triangularNum[2]
    add ebx, eax

    mov eax, [triangularNum + 3 * 4] ; triangularNum[3]
    add ebx, eax

    mov eax, [triangularNum + 4 * 4] ; triangularNum[4]
    add ebx, eax

    mov eax, [triangularNum + 5 * 4] ; triangularNum[5]
    add ebx, eax

    mov eax, [triangularNum + 6 * 4] ; triangularNum[6]
    add ebx, eax

    mov eax, [triangularNum + 7 * 4] ; triangularNum[7]
    add ebx, eax

    mov [somatorio], ebx

fim:
    mov rax, 60
    mov rdi, 0
    syscall
