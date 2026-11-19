; aula 10 atividade 02 - criação de funções - parte dois
; arquivo: a10a02pt2.asm
; objetivo: chamada de sub-programas em x64
; nasm -f elf64 a10a02pt2.asm ; gcc -m64 -no-pie a10a02pt2.o -o a10a02pt2.x && ./a10a02pt2.x

;     *char[ ] upperCase(char* c[ ])
;     *char[ ] lowerCase(char* c[ ])


%define _write  1
%define _read  0
%define _exit   60

section .data
    end : db 10, 0
    endL : equ $-end

    in: db "Entrada: "
    inL: equ $-in

    out: db "Convertido: "
    outL: equ $-out
    
    saida: db "%s usou %d tokens para fazer essas conversoes!", 10, 0

    easterEggkk: dq "Parabens! Voce"
    comum: dq "Olha a água! Voce"


section .bss
    string : resb 26
    stringL : resd 1

section .text
    global main

extern printf

main:
    push rbp
    mov rbp, rsp

    xor r13, r13

leitura:
    mov rax, _write
    mov rdi, 1
    mov rsi, in
    mov rdx, inL 
    syscall

    mov rax, _read
    mov rdi, 0
    mov rsi, string
    mov rdx, 25
    syscall

    ; guarda tamanho da string lida -> vai ser útil depois
    mov [stringL], eax

    mov rdi, string
    call testeExit

    cmp eax, 1
    je contagem

    mov rdi, string
    call testeUpperLower

    cmp eax, 0
    je chamaUp

    mov rdi, string
    call paraLower

    jmp imprime

chamaUp:
    mov rdi, string
    call paraUpper

imprime:
    mov r9, rax
    
    mov rax, _write
    mov rdi, 1
    mov rsi, out
    mov rdx, outL 
    syscall

    
    mov rsi, r9
    mov rax, _write
    mov rdi, 1
    mov edx, [stringL]
    syscall

    inc r13

    jmp leitura


contagem:
    cmp r13, 0
    je easterEgg

    mov rdi, saida
    lea rsi, [comum]
    mov edx, r13d
    call printf
    jmp fim

    easterEgg:
        mov rdi, saida
        lea rsi, [easterEggkk]
        mov edx, r13d
        call printf

fim:
    mov rax, _exit
    mov rdi, 0
    syscall

testeExit:
    mov al, [rdi]
    or al, 0x20
    cmp al, 'e'
    jne recusa

    mov al, [rdi + 1]
    or al, 0x20
    cmp al, 'x'
    jne recusa

    mov al, [rdi + 2]
    or al, 0x20
    cmp al, 'i'
    jne recusa

    mov al, [rdi + 3]
    or al, 0x20
    cmp al, 't'
    jne recusa

    cmp byte [rdi + 4], 10
    je aceita
    cmp byte [rdi + 4], 0
    jne recusa

    aceita:
        mov eax, 1
        ret

    recusa:
        xor eax, eax
        ret


testeUpperLower:
    mov al, [rdi]
    cmp al, 'a'
    jb maiuscula ; o usuario é espero n vou tratar o q ta entre o a e o Z. se deu menor q a (97) vai ser maiuscula
    ; acima de 97 é minuscula
    mov eax, 0
    jmp fora

    maiuscula:
        mov eax, 1
    fora:
        ret

paraLower:
    push rbp
    mov rbp, rsp


    mov rcx, 0
    mov r8d, [stringL]
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
    mov r8d, [stringL]
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