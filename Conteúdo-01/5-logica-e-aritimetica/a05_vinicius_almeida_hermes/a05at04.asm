; Aula 05 - Atividade 04
; arquivo: a05at04.asm
; objetivo: soma de elementos de um vetor
; nasm -f elf64 a05at04.asm && ld a05at04.o -o a05at04.x && gdb ./a05at04.x

section .data
    n: dd 40

section .bss
    enessimotrinumero: resd 1

section .text
    global _start

_start:
    mov eax, 0d
    mov ebx, [n]

    ; ecx = n + 1
    mov ecx, [n]
    add ecx, 1d

    ; n * (n + 1)
    imul ebx, ecx

    ; (n * (n + 1)) / 2
    shr ebx, 1

    mov [enessimotrinumero], ebx

fim:
    mov rax, 60
    mov rdi, 0
    syscall
