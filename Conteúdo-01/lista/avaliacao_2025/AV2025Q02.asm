section .data
    entrada : db "87", 0

section .bss
    resultado : resd 1

section .text
    global _start:

_start:
    ; seu código aqui
    movzx eax, byte [entrada]
    sub eax, '0'
    imul eax, eax, 10
    movzx ebx, byte [entrada + 1]
    sub ebx, '0'
    add eax, ebx
    mov [resultado], eax

_fim:
    mov rax, 60
    mov rdi, 0
    syscall