; Aula 01 - Introdução
; ola.asm
; Meu primeiro assembly!
; montar: nasm -f elf64 ola.asm 
; linkar: ld ola.o -o ola.x
; sugestão: nasm -f elf64 ola.asm && ld ola.o -o ola.x

section .data
    strNome :  db "Vinícius", 10
    strNomeL:  equ $ - strNome

section .text
	global _start

_start:
    mov rax, 1
    mov rdi, 1
    lea rsi, [strNome]
    mov edx, strNomeL
    syscall

    mov rax, 60
    mov rdi, 0
    syscall