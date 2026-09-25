section .data
    dividendo: dd -7
    divisor : dd 4

section .bss
    resto : resd 1

section .text
    global _start

_start:
    

fim:
    mov eax, 60
    mov rdi, 0
    syscall