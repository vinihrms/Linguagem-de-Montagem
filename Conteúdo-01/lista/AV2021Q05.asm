section .data
    vet : dw 1, -2, 3, 5, 8, 10 ; 2 bytes, cada unidade tem 16 bits
    vetS : dd 6 ; double word (4 bytes)

section .bss
    prod : resw 1

section .text
    global _start

;nasm -f elf64 AV2021Q05.asm && ld AV2021Q05.o -o AV2021Q05.x && ./AV2021Q05.x 

_start:
    mov ebx, prod
    mov r8, 0
    mov ecx, vetS
    cmp ecx, 0
    jnp ciclo

ciclo:
    mov eax, [vet + r8 * 2] ; vet[0]
    add ebx, eax

    sub ecx, 1

_fim:
    mov rax, 60
    mov rdi, 0
    syscall