; Atividade Avaliativa 02
; Calcula as distâncias entre 3 pontos (x, y, z) de entrada e escreve em arquivos
; distancias.asm
; nasm -f elf64 distancias.asm ; gcc -m64 -no-pie distancias.o -o distancias.x

; double distancias(double p1[], double p2[])

%define _exit   60
extern printf
extern scanf

section .data
    printEntrada : db "Entre com P%d (ponto flutuante) no formato x y z: ", 0
    scanPontos : db "%lf %lf %lf", 0
    printSaida : db "Distância entre P%d e P%d = %f",10,0

section .bss
    guardaP1 : resd 3 ; x1, y1, z1
    guardaP2 : resd 3 ; x2, y2, z2
    guardaP3 : resd 3 ; x3, y3, z3

    ; distancias
    d1 : resd 1 ; p1 p2
    d2 : resd 1 ; p1 p3
    d3 : resd 1 ; p2 p3
    

section .text
    global main

main:
    ; stack-frame
    push rbp
    mov rbp, rsp

    ; print entrada p1
    xor rax, rax
    mov rdi, printEntrada
    mov esi, 1
    call printf

    ; eax = scanf("%lf %lf %lf", &(scfP1), &(scfP1+4), &(scfP1+8))
    xor rax, rax
    mov rdi, scanPontos
    lea rsi, [guardaP1]
    lea rdx, [guardaP1+8]
    lea rcx, [guardaP1+16]
    call scanf

    ; print entrada p2
    xor rax, rax
    mov rdi, printEntrada
    mov esi, 2
    call printf

    xor rax, rax
    mov rdi, scanPontos
    lea rsi, [guardaP2]
    lea rdx, [guardaP2+8]
    lea rcx, [guardaP2+16]
    call scanf

    ; print entrada p3
    xor rax, rax
    mov rdi, printEntrada
    mov esi, 2
    call printf

    xor rax, rax
    mov rdi, scanPontos
    lea rsi, [guardaP3]
    lea rdx, [guardaP3+8]
    lea rcx, [guardaP3+16]
    call scanf
    
    lea rdi, [guardaP1]
    lea rsi, [guardaP2]
    call distancia2p
    movsd [d1], xmm0

    lea rdi, [guardaP1]
    lea rsi, [guardaP3]
    call distancia2p
    movsd [d2], xmm0

    lea rdi, [guardaP2]
    lea rsi, [guardaP3]
    call distancia2p
    movsd [d3], xmm0

    ; print P1 - P2
    mov eax, 1; 1 argumento double em xmm0
    mov rdi, printSaida
    mov rsi, 1
    mov rdx, 2
    movsd xmm0, [d1]
    call printf


    ; print P1 - P3
    mov eax, 1; 1 argumento double em xmm0
    mov rdi, printSaida
    mov rsi, 1
    mov rdx, 3
    movsd xmm0, [d2]
    call printf

    ; print P2 - P3
    mov eax, 1; 1 argumento double em xmm0
    mov rdi, printSaida
    mov rsi, 2
    mov rdx, 3
    movsd xmm0, [d3]
    call printf

fim:
    ; "destack-frame!"
    mov rsp, rbp
    pop rbp

    mov rax, _exit
    mov rdi, 0
    syscall

distancia2p:
    push rbp
    mov rbp, rsp
    ; movsd porque o scanf guardou em double já
    ; xmm0-2 -> x1, y1, z1
    ; xmm3-5 -> x2, y2, z2
    movsd xmm0, dword [rdi]    ; x1
    movsd xmm1, dword [rdi+8]  ; y1
    movsd xmm2, dword [rdi+16]  ; z1
    movsd xmm3, dword [rsi]    ; x2
    movsd xmm4, dword [rsi+8]  ; y2
    movsd xmm5, dword [rsi+16]  ; z2

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