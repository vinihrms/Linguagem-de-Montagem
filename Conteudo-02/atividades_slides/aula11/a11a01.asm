; aula 11 atividade 01 - distancia entre dois pontos (x, y, z)
; a11a01.asm
; nasm -f elf64 a11a01.asm ; gcc -m64 -no-pie a11a01.o -o a11a01.x

; double dis3Dlm(int p1[], int p2[])
section .data
    pf_p1  : db "Digite as coordenadas (x y z) do ponto 1: ", 0
    pf_p2  : db "Digite as coordenadas (x y z) do ponto 2: ", 0
    sf_p   : db "%d %d %d", 0
    pf_res : db "Distancia 3D = %f", 10, 0

section .bss
    p1     : resd 3     ; int p1[3] = {x1, y1, z1} (12 bytes)
    p2     : resd 3     ; int p2[3] = {x2, y2, z2} (12 bytes)
    dist   : resq 1     ; double (8 bytes)

extern printf
extern scanf

section .text
    global main

main:
    push rbp
    mov rbp, rsp

    ; printf("Digite as coordenadas (x y z) do ponto 1: ");
    xor rax, rax
    mov rdi, pf_p1
    call printf

    ; scanf("%d %d %d", &p1[0], &p1[1], &p1[2]);
    xor rax, rax
    mov rdi, sf_p
    lea rsi, [p1]
    lea rdx, [p1 + 4]
    lea rcx, [p1 + 8]
    call scanf

    ; printf("Digite as coordenadas (x y z) do ponto 2: ");
    xor rax, rax
    mov rdi, pf_p2
    call printf

    ; scanf("%d %d %d", &p2[0], &p2[1], &p2[2]);
    xor rax, rax
    mov rdi, sf_p
    lea rsi, [p2]
    lea rdx, [p2 + 4]
    lea rcx, [p2 + 8]
    call scanf

    ; dist = dis3Dlm(p1, p2);
    mov rdi, p1 
    mov rsi, p2
    call dis3Dlm
    movsd [dist], xmm0  ; salva resultado antes do printf

    ; printf("Distancia 3D = %f\n", dist);
    mov rax, 1 ; 1 float
    mov rdi, pf_res
    movsd xmm0, [dist]
    call printf

fim:
    ; destack-frame
    mov rsp, rbp
    pop rbp
    xor eax, eax
    ret

dis3Dlm:
    ; stack-frame
    push rbp
    mov rbp, rsp

    
    cvtsi2sd xmm0, dword [rsi]
    cvtsi2sd xmm1, dword [rdi]
    subsd    xmm0, xmm1
    mulsd    xmm0, xmm0; xmm0 = dx^2

    cvtsi2sd xmm1, dword [rsi + 4]
    cvtsi2sd xmm2, dword [rdi + 4]
    subsd    xmm1, xmm2
    mulsd    xmm1, xmm1
    addsd    xmm0, xmm1 ; xmm0 = dx^2 + dy^2

    cvtsi2sd xmm1, dword [rsi + 8]
    cvtsi2sd xmm2, dword [rdi + 8]
    subsd    xmm1, xmm2
    mulsd    xmm1, xmm1
    addsd    xmm0, xmm1 ; xmm0 = dx^2 + dy^2 + dz^2

    ; xmm0 = raiz(dx^2 + dy^2 + dz^2)
    sqrtsd   xmm0, xmm0

    ; destack-frame e retorno (resultado em xmm0)
    mov rsp, rbp
    pop rbp
    ret
