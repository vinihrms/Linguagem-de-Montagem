; aula 10 atividade 02 - criação de funções
; arquivo: a10a02.asm
; objetivo: chamada de sub-programas em x64
; nasm -f elf64 a10a02.asm ; ld a10a02.o -o a10a02.x

;     *char[ ] upperCase(char* c[ ])
;     *char[ ] lowerCase(char* c[ ])


%define _write  1
%define _exit   60

section .data
    MEMORIAS : db "DEIXEM-NOS SOS, SEM LIVROS, E IMEDIATAMENTE FICAREMOS CONFUSOS, NOS PERDEREMOS, NAO SABEREMOS A QUEM NOS UNIR, O QUE DEVEMOS APOIAR, O QUE AMAR E O QUE ODIAR, O QUE RESPEITAR E O QUE DESPREZAR. ATE MESMO NOS E DIFiCIL SER GENTE, GENTE COM SEU PROPRIO E VERDADEIRO CORPO E SANGUE...", 0
    memoriasL : equ $-MEMORIAS

    dosubsolo : db "o autor nao resistiu e prosseguiu com elas. mas nos tambem pensamos que e possivel terminar por aqui.", 0
    dosubsoloL : equ $-dosubsolo

    end : db 10, 0
    endL : equ $-end

section .bss
    resultado : resq 1
    resultadoL : resd 1

section .text
    global _start

_start:
    push rbp
    mov rbp, rsp

    ; antes da chamada CALL: passagem de parâmetros
    ; RDI(arg1), RSI(arg2), RDX(arg3), RCX(arg4), R8(arg5) e R9(arg6) + Pilha (direita para esquerda)
    mov rdi, MEMORIAS
    call paraLower

    mov rsi, rax
    mov rax, _write
    mov rdi, 1
    mov rdx, memoriasL 
    syscall

    mov rax, _write
    mov rdi, 1
    mov rsi, end
    mov rdx, endL 
    syscall

    mov rax, _write
    mov rdi, 1
    mov rsi, end
    mov rdx, endL 
    syscall
    mov rax, _write
    mov rdi, 1
    mov rsi, end
    mov rdx, endL 
    syscall
    

    mov rdi, dosubsolo
    call paraUpper

    mov rsi, rax
    mov rax, _write
    mov rdi, 1
    mov rdx, dosubsoloL 
    syscall

    mov rax, _write
    mov rdi, 1
    mov rsi, end
    mov rdx, endL 
    syscall
    
fim:
    mov rax, _exit
    mov rdi, 0
    syscall

  
paraLower:
    push rbp
    mov rbp, rsp


    mov rcx, 0
    mov r8, memoriasL
    dec r8

    LpreBloco:               
        cmp rcx, r8
        jge LsaidaFor
    LblocoFor:
        or byte [rdi + rcx], 0x20
        inc rcx
        jmp LpreBloco

LsaidaFor:
    mov rax, rdi

    mov rsp, rbp
    pop rbp
    ret
   

paraUpper:
    push rbp
    mov rbp, rsp


    mov rcx, 0
    mov r8, dosubsoloL
    dec r8

    UpreBloco:               
        cmp rcx, r8
        jge UsaidaFor
    UblocoFor:
        cmp byte [rdi + rcx], 'a'
        jb Uproximo
        cmp byte [rdi + rcx], 'z'
        ja Uproximo
        and byte [rdi + rcx], 0xDF
    Uproximo:
        inc rcx
        jmp UpreBloco

UsaidaFor:
    mov rax, rdi

    mov rsp, rbp
    pop rbp
    ret