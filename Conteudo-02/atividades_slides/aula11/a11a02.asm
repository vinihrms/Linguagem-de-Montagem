; aula 11 atividade 02 - potencia com ponto flutuante
; a11a02.asm
; nasm -f elf64 a11a02.asm ; gcc -m64 -no-pie a11a02.o -o a11a02.x && ./a11a02.x

; float powlm(float base, int exp)
section .data
    pf_p  : db "Digite a base (float) e o expoente (int): ", 0
    sf_p   : db "%f %d", 0
    pf_res : db "Resultado de %f^%d = %f", 10, 0

section .bss
    base     : resd 1
    expo     : resd 1
    resultado   : resd 1

extern printf
extern scanf

section .text
    global main

main:
    push rbp
    mov rbp, rsp

    ; printf() mensagem
    xor rax, rax
    mov rdi, pf_p
    call printf

    ; scanf("%f %d", &base, &expo);
    xor rax, rax
    mov rdi, sf_p
    lea rsi, [base]
    lea rdx, [expo]
    call scanf

    ; resultado = powlm(base, expo);
    ; float base em xmm0 e int expo em edi
    movss xmm0, dword [base]
    mov edi, dword [expo]
    call powlm
    movss [resultado], xmm0

    ; saída: printf(pf_res, base, expo, resultado)
    mov rax, 2
    mov rdi, pf_res
    cvtss2sd xmm0, dword [base]
    mov esi, dword [expo]
    cvtss2sd xmm1, dword [resultado]
    call printf

fim:
    ; destack-frame
    mov rsp, rbp
    pop rbp
    xor eax, eax
    ret

powlm:
    ; stack-frame
    push rbp
    mov rbp, rsp

    ; xmm0 tem base (float)
    ; edi tem expo (int)

    ; guarda a base e inicializa o resultado com 1.0
    movss xmm1, xmm0
    mov eax, 1
    cvtsi2ss xmm0, eax

    laco:
        test edi, edi
        jz volta
        mulss xmm0, xmm1
        dec edi
        jmp laco

    volta:
        ; valor ta em xmm0
        mov rsp, rbp
        pop rbp
        ret

