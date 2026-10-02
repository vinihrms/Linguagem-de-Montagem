section .data
    arq1 : db '/home/vncs/Desktop/linguagem-de-montagem/Conteúdo-01/lista/avaliacao_2016/teste.txt', 0
    arq2 : db '/home/vncs/Desktop/linguagem-de-montagem/Conteúdo-01/lista/avaliacao_2016/renomeado.txt', 0
    str1 : db 'sucesso',0xa, 0
    str2 : db 'falhou ',0xa, 0

section .text
global _start
_start:
    ; rename()
    mov rax, 82
    lea rdi, [arq1]
    lea rsi, [arq2]
    syscall

    ; verificação
    cmp eax, 0
    jz sucesso
    jmp falha

sucesso:
    mov rax, 1
    mov rdi, 1
    lea rsi, [str1]
    mov rdx, 8
    syscall

falha:
    mov rax, 1
    mov rdi, 1
    lea rsi, [str2]
    mov rdx, 8
    syscall

fim:
    mov rax, 60
    mov rdi, 0
    syscall
; finalização