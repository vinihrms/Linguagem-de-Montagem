;  nasm -f elf64 atividade.asm && ld atividade.o -o atividade.x && gdb ./atividade.x

section .data
    ; p1 - cópia de dados da memória para registrador
    p1r8:  db 0x10
    p1r16: dw 0x2020
    p1r32: dd 0x30303030
    p1r64: dq 0x4040404040404040

    ; parte 2 - cópia de dados de registrador para memória
    p2m8:  db 0x00
    p2m16: dw 0x0000
    p2m32: dd 0x00000000
    p2m64: dq 0x0000000000000000

    ; parte 3 - cópia de dados de imediato para registrador (não contém variáveis)

    ; parte 4 cópia de dados de imediato para memória
    p4m8:  db 0x00
    p4m16: dw 0x0000
    p4m32: dd 0x00000000
    p4m64: dq 0x0000000000000000

section .text
    global _start

; inicio do programa
_start:

parte1:
    mov al, [p1r8]
    mov bx, [p1r16]
    mov ecx, [p1r32]
    mov rdx, [p1r64]

fim:
    mov rax, 60
    mov rdi, 0
    syscall

