section .data
    arq1 : db '/home/guilherme_galante/a.txt', 0
    arq2 : db '/home/guilherme_galante/b.txt', 0
    
    str1 : db 'sucesso',0xa, 0
    str1L:  equ $ - str1 ; isso é q quantidade de caracteres

    str2 : db 'falhou ',0xa, 
    str2L:  equ $ - str2 ; isso é q quantidade de caracteres

section .text
    global _start

; int rename(const char *oldpath, const char *newpath); COLA: colocar ordem de registradores de função

_start:

    ; rename()
    mov rax, 82;
    lea rdi, [arq1]
    lea rsi, [arq2]
    syscall
 
teste:
    ; verificação
    cmp rax, 0
    jne falha
    
    mov rax, 1   ; escrita em terminal
    mov edi, 1
    lea rsi, [str1]
    mov rdx, str1L
    syscall

    jmp fim

falha:
    mov rax, 1   ; escrita em terminal
    mov edi, 1
    lea rsi, [str2]
    mov rdx, str2L
    syscall

fim:
    mov rax, 60
    mov rdi, 0
    syscall

    ; finalização