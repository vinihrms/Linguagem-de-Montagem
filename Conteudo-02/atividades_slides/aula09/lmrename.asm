; Aula 09
; arquivo: lmrename.asm
; objetivo: renomeia arquivos utilizando argv 
; montagem e ling:
    ; nasm -f elf64 lmrename.asm ; ld lmrename.o -o lmrename.x
; uso:
    ; ./lmrename.x mudanca.txt fuga.txt

section .data
    sucesso : dq 'Sucesso', 10, 0
    sucessoL : equ $-sucesso

    falha : dq 'falha', 10, 0
    falhaL : equ $-falha

section .bss
    velho : resq 1
    novo : resq 1

section .text
    global _start

_start:
    pop r9 ;  argc
    pop r9 ; nome do programa : argv[0]

    pop qword [velho]
    pop qword [novo]


    mov rax, 82 ; rename
    mov rdi, [velho]
    mov rsi, [novo]
    syscall

    cmp rax, 0
    jne erro
    
    mov rax, 1 
    mov edi, 1
    lea rsi, [sucesso]
    mov rdx, sucessoL
    syscall

    jmp fim

erro:
    mov rax, 1
    mov edi, 1
    lea rsi, [falha]
    mov rdx, falhaL
    syscall

fim:
    mov rax, 60
    mov rdi, 0
    syscall