; aula 10 atividade 01 - chamada de subprogramas (função)
; arquivo: a10a01.asm
; objetivo: chamada de sub-programas em x64
; nasm -f elf64 a10a01.asm ; ld a10a01.o -o a10a01.x
; gdb ./a10a01.x
; b fim (para consultar 'romeuL', 'julietaL', 'prologoL')

; sub-programa para encontrar o tamanho de string null-terminated
; assinatura em C:
;     int strLength(char *c[]);

%define _write  1
%define _exit   60

section .data
    romeu : db "Mas, silencio! Que luz se escoa por aquela janela?", 0 ; 50 + 1 eh pinga
    julieta : db "O Romeu, Romeu! Por que es tu Romeu?", 0 ; 36 + 1
    prologo : db "Duas famílias, iguais em nobreza, Na bela Verona, onde ocorre a cena, De antigo ódio rompem em nova empresa, E sangue civil mãos civis condena. Dos fatídicos ventres desses rivais, Nasce um par de amantes de má estrela, Cujas tristes ruínas sepultais Enterram a contenda dos pais nela. O curso pavoroso desse amor marcado E a raiva contínua dos seus pais, Que só com a morte dos filhos tem fim dado, São agora o tema de duas horas mais. Se com ouvidos atentos nos escutardes, O que aqui faltar, nós tentaremos suprir mais tarde.", 0 ; 538 + 1

section .bss
    romeuL : resd 1
    julietaL : resd 1
    prologoL : resd 1

section .text
    global _start

_start:
    ; nao tinha nada nos regs nao tem que salvar nada 

    ; antes da chamada CALL: passagem de parâmetros
    ; RDI(arg1), RSI(arg2), RDX(arg3), RCX(arg4), R8(arg5) e R9(arg6) + Pilha (direita para esquerda)
    mov rdi, romeu
    call strLength
    ; retorno do sub-programa em EAX
    mov [romeuL], eax

    ; str2
    mov rdi, julieta
    call strLength
    mov [julietaL], eax

    ; str3
    mov rdi, prologo
    call strLength
    mov [prologoL], eax


fim:
    mov rax, _exit
    mov rdi, 0
    syscall



; subprograma do a10e03.asm
strLength:
    ; passo 1 - Antes do corpo do sub-programa
    ; criar stack-frame
    push rbp
    mov rbp, rsp

    ; passo 2 - Antes do corpo do sub-programa
    ; criar espaço para variáveis locais
    sub rsp, 4  ; 4 bytes para uma variável inteira local
    ; [rsp-4] é o deslocador até encontrar '0'

    ; passo 3 - Antes do corpo do sub-programa
    ; salvar registradores RBX, RDI, RSI, R12 - R15
    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15

    ; sub-programa - inicio -----------------------------
    ; RDI = char *c[] - parâmetro 1
    mov dword [rbp-4], 0
    laco:
        mov edx, [rbp-4]  ; deslocador de 32 bits
        mov al, [rdi+rdx] ; char[deslocador]
        cmp al, 0         ; char é zero?
        je finaliza
        inc edx           ; desloc++
        mov [rbp-4], edx  ; guarda deslocador
        jmp laco

    finaliza:   
    ; sub-programa - fim --------------------------------
   
    ; passo 4 - depois do corpo do sub-programa
    ; copiar resultado para EAX
    mov eax, [rbp-4]
    ; adiciona 1 para contar /0
    inc eax

    ; passo 5 - depois do corpo do sub-programa
    ; recuperar registradores RBX, RDI, RSI, R12 - R15
    pop r15 ; último empilhado
    pop r14
    pop r13
    pop r12
    pop rsi 
    pop rdi
    pop rbx ; primeiro empilhado

    ; passo 6 - depois do corpo do sub-programa
    ; desalocar variáveis locais
    mov rsp, rbp

    ; passo 7 - depois do corpo do sub-programa
    ; recuperar ebp antigo e garantir endereço de retorno
    pop rbp

    ; possível usar leave

    ; passo 8 - depois do corpo do sub-programa
    ; sempre, sempre, sempre retorne com RET
    ret
   
