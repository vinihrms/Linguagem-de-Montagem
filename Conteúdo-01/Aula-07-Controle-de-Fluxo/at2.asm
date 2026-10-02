; nasm -f elf64 a07at01.asm && ld a07at01.o -o a07at01.x && gdb ./a07at01.x

; uhm, macros de constantes? yep! nasm S2
%define maxChars 10

; estabelecendo variaveis definidas
section .data
    strOla : db "Hello?", 10, 0 ; 10 é a quebra de linha e 0 é o fim da string
    strOlaL: equ $ - strOla      ; cuidado: strOlaL "non-existe!" (equ) 

    strBye : db "Voce digitou: ", 0
    strByeL: equ $ - strBye 

    strLF  : db 10 ; quebra de linha ASCII!
    strLFL : dd 1

    strQuit: db "quit", 0
    strQuitL: equ $ - strQuit

section .bss
    strLida  : resb maxChars
    strLidaL : resd 1
    tmp: resb 1

section .text
 	global _start

; NOTA: fd (file descriptor): 0 = entrada; 1 = saida tela; 2 = mensagem de erro

_start:
    ; escrita

    ; ssize_t write(int fd , const void *buf, size_t count);
    ; eax     write(int edi, const void *rsi, size_t edx  );
    ; quando tem * é ponteiro entao é ; lea reg, [var]
    mov rax, 1
    mov edi, 1  ; std_file
    lea rsi, [strOla]
    mov edx, strOlaL
    syscall


leitura:

    mov dword [strLidaL], maxChars ; %define é constantes!

    ; ssize_t read(int fd , const void *buf, size_t count);
    ; eax     read(int edi, const void *rsi, size_t edx  );

    mov rax, 0  ; READ
    mov edi, 0
    lea rsi, [strLida]
    mov edx, [strLidaL]
    syscall

    mov [strLidaL], eax

    ; Compara o que foi digitado com "quit" (não com strOla).
    ; strQuitL inclui o byte terminador zero, por isso compare só 4 bytes.
    lea rsi, [strLida]           ; Fonte
    lea rdi, [strQuit]           ; Destino
    mov rcx, strQuitL - 1        ; Registrador RCX: bytes a comparar
    
    cld                        ; Limpa o Direction Flag (garante incremento progressivo: RSI++, RDI++)
    repe cmpsb                 ; Compara byte por byte enquanto forem iguais (e RCX > 0)

    jne resposta             ; Se quebrou o loop antes do fim, são diferentes

    ; Evita aceitar entradas como "quitx". No terminal, "quit" vem com LF.
    cmp dword [strLidaL], 5
    jne resposta
    cmp byte [strLida + 4], 10
    je fim
    jne resposta
    
resposta:

    ; voce escreveu: 
    mov rax, 1  ; WRITE
    mov edi, 1
    lea rsi, [strBye]
    mov rdx, strByeL
    syscall

    ; palavea que escrevemos
    mov rax, 1  ; WRITE
    mov edi, 1
    lea rsi, [strLida]
    mov edx, [strLidaL]
    syscall

    ; Se o buffer ficou cheio, ainda há caracteres (e o Enter) no
    ; buffer do terminal. Consome tudo até a quebra de linha.
    cmp dword [strLidaL], maxChars
    je esvazia_buffer

    ; Com menos caracteres, o read já trouxe o Enter.
    jmp leitura

esvazia_buffer:
    mov rax, 0              ; READ
    mov edi, 0
    lea rsi, [tmp]
    mov edx, 1
    syscall

    
    cmp byte [tmp], 10
    jne esvazia_buffer

    ; O Enter foi consumido, portanto imprime uma única quebra.
    mov rax, 1              ; WRITE
    mov edi, 1
    lea rsi, [strLF]
    mov edx, [strLFL]
    syscall

    jmp leitura

imprime_fim:
    ; mantido como rótulo compatível com a versão original
    jmp esvazia_buffer

maior:
    

fim:
    ; void _exit(int status);
    ; void _exit(int ebx   );
    mov rax, 60
    mov edi, 0
    syscall
