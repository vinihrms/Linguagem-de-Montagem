; Aula 04 - Dados Nao-Inicializados e Estrutura
; arquivo: atividade.asm
; Atividade
; nasm -f elf64 atividade.asm && ld atividade.o -o atividade.x && gdb ./atividade.x

section .data
    ; vetor largura, altura e profundidade
    dimensoes : dw 50, 65, -75 ; dw 16 = 0x0000

section .bss
    volume : resq 1

section .text
    global _start

_start:
    ; aluno deve:
        lea r11, [dimensoes]
        lea r12, [dimensoes + 2]
        lea r13, [dimensoes + 4]

        ; mover largura para registrador r8?
        mov r8, [r11]

        ; mover altura para registrador r9?
        mov r9, [r12]

        ; mover profundidade para registrador r10?
        mov r10, [r13]
teste:
        ; ter cuidado com os tamanhos dos registradores

    ; código base para o cálculo, não alterar!
        xor dx, dx
        mov ax, r8w
        imul r9w
        imul r10w
        
        mov cx, dx
        shl ecx, 16
        mov cx, ax
        ; resposta 
        ; volume = dimensoes[0] * dimensoes[1] * dimensoes[2]
        ; ecx = volume

    ; aluno deve:
        ; mover resultado ecx para volume
        ; cuidado com o sinal
    movsx rbx, ecx

    mov [volume], rbx

fim:
    mov rax, 60
    mov rdi, 0
    syscall



