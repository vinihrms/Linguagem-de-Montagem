<<<<<<< HEAD
; aula 11 atividade 02 - potênca de base ponto flutuante
; a11a02.asm
; nasm -f elf64 a11a02.asm ; gcc -m64 -no-pie a11a02.o -o a11a02.x && ./a11a02.x

; float pow(float base, int expo)

%define _exit   60
extern printf
extern scanf

section .data
    pfstr1 : db "Entre com a base (float) e o expoente: ", 0
    scstr1 : db "%f %d", 0
    pfstr2 : db "A potência é = %f",10,0

section .bss
    base : resd 1
    expo : resd 1
    resp : resq 1
=======
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
>>>>>>> 190caa7b575fe044526cdcbe7f5bce39141f5c28

section .text
    global main

main:
<<<<<<< HEAD
=======
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
>>>>>>> 190caa7b575fe044526cdcbe7f5bce39141f5c28
    ; stack-frame
    push rbp
    mov rbp, rsp

<<<<<<< HEAD
    ; eax = printf("Entre com Ponto_%d (int) no formato x y z: ", 1);
    xor rax, rax
    mov rdi, pfstr1 ; string de controle para printf
    mov esi, 1
    call printf

    ; eax = scanf("%f %d", &(base), &(expo))
    xor eax, eax
    mov rdi, scstr1
    lea rsi, [base]
    lea rdx, [expo]
    call scanf
  

    lea rdi, base
    lea rsi, expo    
    call pow

    movsd [resp], xmm0

    ; print para resposta
    ; eax = printf("Distância é = %f\n", xmm0);
    mov eax, 1      ; 1 argumento double em xmm0
    mov rdi, pfstr2 ; string de controle para printf
    movsd xmm0, [resp]
    call printf

fim:
    ; "destack-frame!"
    mov rsp, rbp
    pop rbp

    mov rax, _exit
    mov rdi, 0
    syscall

pow:
    push rbp
    mov rbp, rsp
    cvtss2sd xmm1, dword [rdi]     ; base
    mov ecx, dword [rsi]        ; expoente

    ; resultado inicial: 1.0 para expo 0
    mov eax, 1
    cvtsi2sd xmm0, eax

    test ecx, ecx
    jz volta

    multi:
        mulsd xmm0, xmm1
        dec ecx
        jnz multi

volta:
    mov rsp, rbp
    pop rbp
    ret
=======
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

>>>>>>> 190caa7b575fe044526cdcbe7f5bce39141f5c28
