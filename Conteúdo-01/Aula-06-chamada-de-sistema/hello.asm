; Aula 01 - Introdução
; hello.asm
; Meu primeiro assembly!
; nasm -f elf64 hello.asm && ld hello.o -o hello.x && gdb ./hello.x

section .data
    strOla :  db "Ola", 10
    strOlaL:  equ $ - strOla ; isso é q quantidade de caracteres

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    lea rsi, [strOla] ; ele recebe como se fosse um ponteiro para a o primeiro byte da string
    mov edx, strOlaL
    syscall

fim:
    mov rax, 60
    mov rdi, 0
    syscall
