; nasm -f elf64 divisao_double_to_float.asm ; ld divisao_double_to_float.o -o divisao_double_to_float.x && ./divisao_double_to_float.x

section .data
    num1: dq 11.4
    num2: dq 30.0

section .bss
    resp: resd 1

section .text
    global _start

_start:
    MOVSD xmm8, [num1]
    MOVSD xmm9, [num2]

    DIVSD xmm8, xmm9

    CVTSD2SS xmm8, xmm8

    MOVSS [resp], xmm8
fim:
    mov rax, 60
    mov rdi, 0
    syscall

