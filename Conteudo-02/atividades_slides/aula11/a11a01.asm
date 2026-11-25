; aula 11 atividade 01 - distancia entre dois pontos (x, y, z)
; a11a01.asm
; nasm -f elf64 a11a01.asm ; gcc -m64 -no-pie a11a01.o -o a11a01.x

; double dis3Dlm(int p1[], int p2[])
<<<<<<< HEAD

%define _exit   60
extern printf
extern scanf

section .data
    pfstr1 : db "Entre com Ponto_%d (int) no formato x y z: ", 0
    scstr1 : db "%d %d %d", 0
    pfstr2 : db "Distância é = %f",10,0

section .bss
    scfP1 : resd 3 ; x1,y1,z1
    scfP2 : resd 3 ; x2,y2,z2
    resp : resq 1
=======
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
>>>>>>> 190caa7b575fe044526cdcbe7f5bce39141f5c28

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

<<<<<<< HEAD
    ; eax = printf("Entre com Ponto_%d (int) no formato x y z: ", 1);
    xor rax, rax
    mov rdi, pfstr1 ; string de controle para printf
    mov esi, 1
    call printf

    ; eax = scanf("%d %d %d", &(scfP1), &(scfP1+4), &(scfP1+8))
    xor rax, rax
    mov rdi, scstr1
    lea rsi, [scfP1]   ; x1 ; Load Efective Address!!!
    lea rdx, [scfP1+4] ; y1
    lea rcx, [scfP1+8] ; y1
    call scanf
  

  ; eax = printf("Entre com Ponto_%d (int) no formato x y z: ", 2);
    xor rax, rax
    mov rdi, pfstr1 ; string de controle para printf
    mov esi, 2
    call printf

    ; eax = scanf("%d %d %d", &(scfP2), &(scfP2+4), &(scfP2+8))
    xor rax, rax
    mov rdi, scstr1    ; mesma entrada
    lea rsi, [scfP2]   ; x2 ; Load Efective Address!!!
    lea rdx, [scfP2+4] ; y2
    lea rcx, [scfP2+8] ; y2
    call scanf


    lea rdi, scfP1
    lea rsi, scfP2    
    call dis3Dlm

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

dis3Dlm:
    push rbp
    mov rbp, rsp
    ; conversão para double já em registradores
    ; xmm0-2 -> x1, y1, z1
    ; xmm3-5 -> x2, y2, z2
    cvtsi2sd xmm0, dword [rdi]    ; x1
    cvtsi2sd xmm1, dword [rdi+4]  ; y1
    cvtsi2sd xmm2, dword [rdi+8]  ; z1
    cvtsi2sd xmm3, dword [rsi]    ; x2
    cvtsi2sd xmm4, dword [rsi+4]  ; y2
    cvtsi2sd xmm5, dword [rsi+8]  ; z2

    ; xmm0 = (x1 - x2)^2  
    subsd xmm0, xmm3    ; (x1 - x2)
    mulsd xmm0, xmm0    ; ^2

    ; xmm1 = (y1 - y2)^2  
    subsd xmm1, xmm4    ; (y1 - y2)
    mulsd xmm1, xmm1    ; ^2
    
    ; xmm2 = (z1 - z2)^2  
    subsd xmm2, xmm5    ; (z1 - z2)
    mulsd xmm2, xmm2    ; ^2

    ; adição das 3 diferenças ao quadrado
    addsd xmm0, xmm1    
    addsd xmm0, xmm2

    ; raiz quadrada em xmm0
    sqrtsd xmm0, xmm0

    mov rsp, rbp
    pop rbp
    ret
=======
    
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
>>>>>>> 190caa7b575fe044526cdcbe7f5bce39141f5c28
