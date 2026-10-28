; Recuperação 01
; Arquivo: viniciusHermes.asm

; Objetivo: 
    ; Ler do teclado um valor numérico
    ; Transformar em vetor
    ; Calcular o menor valor, com sua posição e exibir a soma

; montar, linkar e executar
; nasm -f elf64 viniciusHermes.asm && ld viniciusHermes.o -o viniciusHermes.x && ./viniciusHermes.x


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; INICIO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; n sei se vc ja passou isso mas eu procurei voluntariamente na internet pra ver se
;    tinha algo que dava pra abstrair esse write de \n 
%macro endL 0
    mov rax, 1
    mov edi, [fd]
    lea rsi, [quebra]
    mov edx, quebraL
    syscall
%endmacro

%define maximoEntrada 20

; estabelecendo variaveis definidas
section .data
    strEntrada : db "Digite os digitos do vetor (max 20): "
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
    mov dword [strLidaL], maximoEntrada

    ; LEITURA ENTRADA
    mov rax, 0
    mov edi, 0
    lea rsi, [strLida]
    mov edx, [strLidaL]
    syscall

    mov [strLidaL], eax
    cmp eax, 0
    jle fimConverte

remove_quebra_linha:
    xor rcx, rcx
    mov ecx, [strLidaL]
    dec rcx ; ultimo caracter lido é esse
    mov al, [strLida + rcx]
    cmp al, 10 ; ve se o ultimo é \n, se n for é pq sobrou coisa
    jne limpa_buffer
    
    mov [strLidaL], ecx
    jmp preLaco

limpa_buffer: ; só entra aqui se estourou
    mov rax, 0
    mov edi, 0
    lea rsi, [tmp]
    mov edx, 1
    syscall
    
    cmp eax, 0                  
    jle preLaco

    cmp byte [tmp], 10 ; lê byte a byte até achar \n
    jne limpa_buffer

preLaco:
    xor r8, r8
    xor r9, r9
    xor rcx, rcx
    xor r10, r10
    xor r11, r11

    mov r8d, [strLidaL]

converteCada:
    cmp r9, r8
    jge fimConverte

    cmp r9, 0
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
    ; nesses rN pode ter bo -> mesmo esquema do collatz ja q n teve pilha no conteudo da p1
    ; r11 indice do menor
    ; r10 é p ter somatorio

    add cl, '0' ; menor digito está pronto para ser exibido
    mov [strMenor], cl



int_para_ascii_INDICE:
    mov eax, r11d
    mov ebx, 10
    xor r9, r9 ; usar isso de incide (para inverter a string dps)

divisoes_INDICE:
    xor edx, edx
    div ebx

    add edx, '0' ; soma para converter para ASCII
    mov [strIndice + r9], dl ; isso vai gravar ao inverso

    inc r9
    test eax, eax
    jnz divisoes_INDICE

reverte_strIndice_INDICE:
    xor rcx, rcx
    lea rdx, [r9 - 1]  ; fim é quantidade - 1

troca_INDICE:
    cmp rcx, rdx
    jge fim_reverte_INDICE

    mov al, [strIndice + rcx]
    mov bl, [strIndice + rdx]

    mov [strIndice + rcx], bl
    mov [strIndice + rdx], al

    inc rcx
    dec rdx
    jmp troca_INDICE

fim_reverte_INDICE:
    mov [strIndiceL], r9b




int_para_ascii_SOMA:
    mov eax, r10d
    mov ebx, 10
    xor r9, r9 ; usar isso de incide (para inverter a string dps)

divisoes_SOMA:
    xor edx, edx
    div ebx

    add edx, '0' ; soma para converter para ASCII
    mov [strSoma + r9], dl ; isso vai gravar ao inverso

    inc r9
    test eax, eax
    jnz divisoes_SOMA

reverte_strSoma_SOMA:
    xor rcx, rcx
    lea rdx, [r9 - 1]  ; fim é quantidade - 1

troca_SOMA:
    cmp rcx, rdx
    jge fim_reverte_SOMA

    mov al, [strSoma + rcx]
    mov bl, [strSoma + rdx]

    mov [strSoma + rcx], bl
    mov [strSoma + rdx], al

    inc rcx
    dec rdx
    jmp troca_SOMA

fim_reverte_SOMA:
    mov [strSomaL], r9b


gravacao:
; abertura
    mov rax, 2
    lea edi, [strArquivo]
    mov esi, 2101o
    mov edx, 644o
    syscall

    mov [fd], eax ; guardo descritor do arquivo

    ; Vetor :
    mov rax, 1
    mov edi, [fd]
    lea esi, [outVetor]
    mov edx, outVetorL
    syscall

    ; vetor lido
    mov rax, 1
    mov edi, [fd]
    lea esi, [strLida]
    mov edx, [strLidaL]
    syscall

    endL

    ; Menor: 
    mov rax, 1
    mov edi, [fd]
    lea esi, [outMenor]
    mov edx, outMenorL
    syscall

    ; menor valor
    mov rax, 1
    mov edi, [fd]
    lea esi, [strMenor]
    mov edx, 1
    syscall

    endL

    ; Posicao: 
    mov rax, 1
    mov edi, [fd]
    lea esi, [outPosicao]
    mov edx, outPosicaoL
    syscall

    ; valor do indice
    mov rax, 1
    mov edi, [fd]
    lea esi, [strIndice]
    movzx edx, byte [strIndiceL]
    syscall

    endL

    ; Soma: 
    mov rax, 1
    mov edi, [fd]
    lea esi, [outSoma]
    mov edx, outSomaL
    syscall

    ; valor da soma 
    mov rax, 1
    mov edi, [fd]
    lea esi, [strSoma]
    movzx edx, byte [strSomaL]
    syscall

    endL

    ; ---
    mov rax, 1
    mov edi, [fd]
    lea esi, [outSepara]
    mov edx, outSeparaL
    syscall

    endL

    mov rax, 3
    mov edi, [fd]
    syscall

fim:
    mov rax, 60
    mov edi, 0
    syscall