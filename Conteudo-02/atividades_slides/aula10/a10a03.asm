; aula 10 atividade 03 - fatorial recursivo
; arquivo: a10a03.asm
; objetivo: calcular fatorial de n de forma recursiva
; nasm -f elf64 a10a03.asm ; gcc -m64 -no-pie a10a03.o -o a10a03.x && ./a10a03.x

;int fatorial(n)

%define _write  1
%define _exit   60

section .data
    fatorialDe : db "Fatorial de: ", 0
    fatorialDeL : equ $-fatorialDe

    scan : db "%d", 0

    eh : db "eh %lld", 10, 0
    ehL : equ $-eh

section .bss
    entrada : resq 1
    resultado : resq 1

section .text
    global main

extern printf
extern scanf


main:
    push rbp
    mov rbp, rsp

    ; printf("Fatorial de: ");
    xor rax, rax
    mov rdi, fatorialDe
    call printf

    ; scanf("%d", &entrada);
    xor rax, rax
    mov rdi, scan
    lea rsi, [entrada]
    call scanf

    mov rdi, [entrada]
    call fatorial
    mov [resultado], rax

    ; printf("eh %lld\n", resultado);
    xor rax, rax
    mov rdi, eh
    mov rsi, [resultado]
    call printf

fim:
    mov rax, _exit
    mov rdi, 0
    syscall

fatorial:
    push rbp
    mov rbp, rsp

    cmp rdi, 1
    jle um

    push rdi
    dec rdi
    call fatorial
    pop rdi
    imul rax, rdi
    jmp fim_fatorial

    um:
        mov rax, 1

    fim_fatorial:
        mov rsp, rbp
        pop rbp
        ret