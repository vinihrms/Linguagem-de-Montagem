; Recuperação 01
; Arquivo: viniciusHermes_r1.asm

; Objetivo: 
    ; Ler do teclado um valor numérico
    ; Transformar em vetor
    ; Calcular o menor valor, com sua posição e exibir a soma

; montar, linkar e executar
; nasm -f elf64 viniciusHermes_r1.asm && ld viniciusHermes_r1.o -o viniciusHermes_r1.x && ./viniciusHermes_r1.x


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; INICIO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%define maximoEntrada 20

; estabelecendo variaveis definidas
section .data
    strEntrada : db "Digite os digitos do vetor (max 20): ", 0
    strEntradaL: equ $ - strEntrada

    outVetor : db "Vetor: "
    outVetorL: equ $ - outVetor

    outMenor : db "Menor: "
    outMenorL: equ $ - outMenor

    outPosicao : db "Posicao: "
    outPosicaoL: equ $ - outPosicao

    outSoma : db "Soma: "
    outSomaL: equ $ - outSoma

    outSepara : db "---"
    outSeparaL: equ $ - outSepara

    strArquivo: db "resultado.txt", 0
    srtArquivo: equ $ - strArquivo

    ; auto explicativo
    quebra : db 10
    quebraL: equ $ - quebra


section .bss
    strLida  : resb maximoEntrada
    strLidaL : resd 1

    tmp: resb 1

    fd: resd 1
    strMenor  : resb 4
    strMenorL  : resb 1

    strIndice  : resb 4
    strIndiceL  : resb 1

    strSoma  : resb 4
    strSomaL  : resb 1

section .text
    global _start

_start:
    ; ESCRITA MSG INICIAL
    mov rax, 1
    mov edi, 1  ; std_file
    lea rsi, [strEntrada]
    mov edx, strEntradaL
    syscall

leitura:
    mov dword [strLidaL], maxChars

    ; LEITURA ENTRADA
    mov rax, 0
    mov edi, 0
    lea rsi, [strLida]
    mov edx, [strLidaL]
    syscall

    mov [strLidaL], eax

    mov ecx, eax
    dec ecx
    
    cmp byte [strLida + rcx], 10
    je remove_quebra_linha 

    jmp esvazia_buffer

remove_quebra_linha:
    dec dword [strLidaL]
    jmp converter

; se nao segue para ca
esvazia_buffer: ; isso veio do papagali
    mov rax, 0
    mov edi, 0
    lea rsi, [tmp]
    mov edx, 1
    syscall
    
    cmp byte [tmp], 10
    jne esvazia_buffer  

    xor r9, r9
    mov r8, [strLidaL] ; contador

    xor r10, r10 ;  esse vai ser onde vai ficar a soma!
    xor r11 ; posicao do menor

converteCada:
    test r9, r8
    jz fimConverte

    test r9, 0
    jnz naoPrimeira ; se não é a primeira consigo acessar strLida[i - 1]
    ; se é a primeira eu já jogo o primeiro valor para o reg do menor (cl) e comparo com ele as proximas

    mov cl, [strLida + r9] ; strLida[i] para al
    sub cl, '0'

    movzx rbx, cl ; aqui cl armazena o primeiro valor (que é o menor até então)
    add r10, rbx ; somatorio do vetor!
    mov r11, r9 ; guarda indice

    inc r9
    jmp converteCada
    
    ; aqui já é segunda vez no laco
    naoPrimeira: 

        ; passou da primeira, o valor anterior ja esta em al
        mov bl, [strLida + r9] ; strLida[i] para bl
        sub bl, '0'

        movzx rax, bl ; somatorio com o atual
        add r10, rax

        cmp cl, bl
        jle naoAtualizaMenor ; <= porque tem que ser a primeira ocorrencia
        
        ; aqui atualiza o menor
        mov r11, r9
        mov cl, bl 

        naoAtualizaMenor:
            inc r9 
            jmp converteCada 

; aqui espera-se o vetor com cada posicao ter o valor inteiro
fimConverte:
    ; cl o menor  ; aqui é um valor unitario, pode somar '0' sem ko
    ;; nesses rN pode ter bo 
    ; r11 indice do menor
    ; r10 é p ter somatorio


    
    add cl, '0'

    mov byte


gravacao:
    ; abertura
    mov rax, 2
    lea edi, [strArquivo]
    mov esi, 2101o
    mov edx, 644o
    syscall

    mov [fd], eax ; guardo descritor do arquivo

    ; parte 1 da escrita
    mov rax, 1
    mov edi, [fd]
    lea esi, [outP1]
    mov edx, outP1L
    syscall

    ; string com a entrada
    mov rax, 1
    mov edi, [fd]
    lea esi, [strLida]
    mov edx, [strLidaL]
    syscall

    ; parte 2 da escrita
    mov rax, 1
    mov edi, [fd]
    lea esi, [outP2]
    mov edx, outP2L
    syscall

    ;;;;;; aqui tem que gravar as iteracoes convertidas
    ; mov rax, 1
    ; mov edi, [fd]
    ; lea esi, [teste]
    ; mov edx, testeL
    ; syscall

    ; feito
    mov rax, 1
    mov edi, [fd]
    lea esi, [strIteracoes]
    mov edx, [strIteracoesL]
    syscall

    ; parte 3 da escrita
    mov rax, 1
    mov edi, [fd]
    lea esi, [outP3]
    mov edx, outP3L
    syscall

    mov rax, 3
    mov edi, [fd]
    syscall

fim:
    mov rax, 60
    mov edi, 0
    syscall
; só p dar 300 linhas certinho. o toc nao deixa largar o jeito q tava