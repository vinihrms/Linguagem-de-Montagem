; Trabalho 01 - Collatz(n)
; Arquivo: collatz.asm

; Objetivo: 
    ; Calcular a sequência de Collatz para cada entrada, e ao final de cada execução,
        ; escreve a entrada digitada e a quantidade de passos no arquivo collatz.txt
    ; Caso o arquivo não exista, ele é criado na primeira execução.
    ; A entrada do usuário deve ser um valor de no máximo 2 digítos com exclusão do 0,
        ; ou seja, intervalo [1, 99].
    ; O programa rejeita e encerra entradas inválidas.

; montar, linkar e executar
; nasm -f elf64 collatz.asm && ld collatz.o -o collatz.x && ./collatz.x

; use isto para testar de 1 a 99 (depois de já montado e linkado uma vez 
;       [limpe ou apague o collatz.txt])
;for i in $(seq 1 99); do
;    printf '%s\n' "$i" | ./collatz
;done

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; INICIO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 3 caracteres para permitir enrtrada de qualquer valor e armazenará 3 digitos
    ; e se for maior que 99, ainda guardar o valor digitado para sempre converter
    ; e dar erro de for valor > 99
%define maxChars 4

; estabelecendo variaveis definidas
section .data
    strEntrada : db "Digite um valor: ", 0
    strEntradaL: equ $ - strEntrada

    strErro : db "ERRO: Você digitou um valor inválido! Programa encerrado!", 10, 0
    strErroL: equ $ - strErro 

    outP1 : db "Entrada: "
    outP1L: equ $ - outP1
    
    teste : db "67"
    testeL: equ $ - teste

    outP2 : db ". Iteracoes: "
    outP2L: equ $ - outP2

    outP3 : db ".", 10
    outP3L: equ $ - outP3

    strArquivo: db "collatz.txt", 0
    srtArquivo: equ $ - strArquivo

section .bss
    strLida  : resb maxChars
    strLidaL : resd 1

    tmp: resb 1

    fd: resd 1
    strIteracoes  : resb 4
    strIteracoesL  : resb 1

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

converter:
    mov ecx, [strLidaL]
    ; um digito tem tamanho 2 "1\n"
    ; dois digitos tem tamanho 3 "22\n"
    ; tres digitos tem tamanho 4 "333\n"

    cmp ecx, 1
    je um_digito

    cmp ecx, 2
    je dois_digitos

    ; passou de um ou digitos obviamente (kkkkk) já da p presumir que
    ;       o que foi digitado é > 99
    jmp erro 

um_digito:
    movzx eax, byte [strLida]
    sub eax, '0'

    jmp verifica

; isso veio da atividade do 87 e o "um_digito" e "resto" seguem o mesmo padrao
dois_digitos:
    movzx eax, byte [strLida]
    sub eax, '0'
    imul eax, eax, 10
    movzx ebx, byte [strLida + 1]
    sub ebx, '0'
    add eax, ebx

    jmp erro ; se ta aqui é pq estourou então tá errado
    
verifica:
    cmp eax, 0
    je erro

    ; vai que né
    cmp eax, 99
    jg erro

    ; nota que o valor original já esta em strLida (com \n)
    ; escrito em ascii mesmo, isso vai ser útil mais tarde

    ; r15 sera o contador das iteracoes (aqui inicia com 0)
    xor r15, r15

    ; guarda o valor original em r8d
    mov r8d, eax

; se passou disso, espera-se um valor válido em eax para iniciar a sequencia de Collatz :))))
enquanto_nao_um:
    cmp eax, 1
    je int_para_ascii
    
    mov edx, 0
    mov ebx, 2
    div ebx ; divisao resto vai pra edx
     ;se for qualquer coisa diferente de zero é impar

    cmp edx, 0
    je par
    jmp impar
    
par:
    ; isso volta o valor certo para eax depois da divisao do teste
    ;   se é par ou impar
    mov eax, r8d
    shr eax, 1
    ; isso preserva o valor da divisao para voltar depois de testar 

    mov r8d, eax
    jmp fecha_laco_e_volta

impar:
    mov eax, r8d
    imul eax, eax, 3
    inc eax
    mov r8d, eax
    jmp fecha_laco_e_volta

fecha_laco_e_volta:
    inc r15
    jmp enquanto_nao_um

erro:
    mov rax, 1
    mov edi, 1
    lea rsi, [strErro]
    mov edx, strErroL
    syscall
    jmp fim

int_para_ascii:
    mov eax, r15d
    mov ebx, 10
    xor r9, r9 ; usar isso de incide (para inverter a string dps)

divisoes:
    xor edx, edx
    div ebx

    add edx, '0' ; soma para converter para ASCII
    mov [strIteracoes + r9], dl ; isso vai gravar ao inverso

    inc r9
    test eax, eax
    jnz divisoes

reverte_strIteracoes:
    xor ecx, ecx
    lea rdx, [r9 - 1]  ; fim é quantidade - 1

troca: ; isso veio da prova kkkkkk ajudou muito
    cmp rcx, rdx
    jge fim_reverte

    mov al, [strIteracoes + rcx]
    mov bl, [strIteracoes + rdx]

    mov [strIteracoes + rcx], bl
    mov [strIteracoes + rdx], al

    inc rcx
    dec rdx
    jmp troca

fim_reverte:
    mov [strIteracoesL], r9b

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