; nasm -f elf64 argc.asm ; ld argc.o -o argc.x && gdb --args ./argc.x 1 2 3 4
; nasm -f elf64 argc.asm ; gcc -m64 -no-pie argc.o -o argc.x && ./argc.x 1 2 3 4
section .data
    printar: db "Este programa tem %d argumentos (excluindo o proprio nome).", 10, 0

section .bss
    argc: resd 1

section .text
    global main


_start:
    pop rax
    mov dword [argc], eax

fim:
    mov rax, 60
    mov rdi, 0
    syscall