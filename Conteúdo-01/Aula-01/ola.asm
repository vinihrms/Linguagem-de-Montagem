; Aula 01 - Introdução
; hello.asm
; Meu primeiro assembly!
; montar: nasm -f elf64 hello.asm 
; lingar: ld hello.o -o hello.x
; sugestão: nasm -f elf64 hello.asm && ld hello.o -o hello.x

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