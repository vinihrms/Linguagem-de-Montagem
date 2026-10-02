section .data
    dividendo: dd -7
    divisor : dd 4

section .bss
    resto : resd 1
    resultado: resd 1

section .text
    global _start:

_start:
    mov eax, [dividendo]
    cdq
    idiv dword [divisor]
    mov [resultado], eax
    mov [resto], edx

fim:
    mov eax, 60
    mov rdi, 0
    syscall
