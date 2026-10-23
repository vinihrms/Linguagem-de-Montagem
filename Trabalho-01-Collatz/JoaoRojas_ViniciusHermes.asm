; Trabalho 01 - Implementação do Collatz
; arquivo: JoaoRojas_ViniciusHermes.asm
; 
; nasm -f elf64 JoaoRojas_ViniciusHermes.asm && ld JoaoRojas_ViniciusHermes.o -o JoaoRojas_ViniciusHermes.x

section .data
   ; mensagem de início
   strLeitura : db "Digite um número entre [1 - 99]: "
   strLeitura_Len: equ $ - strLeitura

   ; mensagem de erro
   strErro : db "Erro, não foi possível concluir"
   strErro_Len: equ $ - strErro

   ; nome do arquivo que será gerado
   nomeArquivo: db "collatz.txt", 0

   ; strings para escrever no arquivo
   strNumero: db "Numero de entrada: "
   strNumero_Len: equ $ - strNumero
   strPassos: db " -> Quantidade de passos: "
   strPassos_Len: equ $ - strPassos

   ; quebra linha
   quebra_Linha : db 10

section .bss
   ; vetor que armazena os valores de entrada
   valorEntrada  : resb 3

   ; valor aonde realiza as operações
   valorOperador : resq 1
   contador : resb 1

   ; vetor que armazena o valor em ASCII do contador de passos
   contador_Em_ASCII : resb 3

   ; byte para descartar o buffer
   byteDescarte : resb 1

section .text
	global _start

_start:
   ; Zerando contador
   mov byte [contador], 0

   ; Syscall Write para a mensagem inicial
   mov rax, 1  
   mov rdi, 1
   lea rsi, [strLeitura]
   mov rdx, strLeitura_Len
   syscall

   ; Syscall Read para ler o valor de entrada
   mov rax, 0 
   mov rdi, 0
   lea rsi, [valorEntrada]
   mov rdx, 3
   syscall

   ; em seguida é realizado comparações para ver quantos
   ; caracteres foram passados na entrada, se estiver fora do 
   ; intervalo de [0, 99] aparece mensagem de erro
   cmp rax, 1
   je mensagemErro

   cmp rax, 2
   je .umdigito

   cmp byte [valorEntrada + 2], 10
   je .doisdigitos

   jmp limpabuffer

   ; é executado caso a entrada for de dois dígitos
   .doisdigitos:
      ; r13 é utilizado no final para indicar que a entrada 
      ; foi de 2 digitos e escrever eles no arquivo 
      mov r13, 2
      
      mov al, [valorEntrada]
      mov bl, [valorEntrada + 1]

      ; Trocar o valor de entrada de ASCII para binário
      sub al, '0'
      sub bl, '0'

      ; Realiza notação posicional
      ; exemplo: 57d é escrito como (10*5) + 7
      movsx rax, al
      imul rax, 10
      movsx rbx, bl
      add rax, rbx
      mov [valorOperador], rax

      ; comparação para ver se a entrada for = 0
      cmp qword [valorOperador], 0
      je mensagemErro

      jmp loop
   
   ; é executado caso a entrada for de um dígito
   .umdigito:
      ; r13 é utilizado no final para indicar que a entrada 
      ; foi de 1 digito e escrever ele no arquivo 
      mov r13, 1
      
      mov al, [valorEntrada]

      ; Trocar o valor de entrada de ASCII para binário
      sub al, '0'
      movsx rax, al
      mov [valorOperador], rax

      ; Comparação para ver se a entrada é 0
      cmp qword [valorOperador], 0
      je mensagemErro

      jmp loop


mensagemErro:
   ; Printa a mensagem de erro com a syscall write
   mov rax, 1  
   mov rdi, 1
   lea rsi, [strErro]
   mov rdx, strErro_Len
   syscall

   ; Printa a quebra de linha com a syscall write
   mov rax, 1  
   mov rdi, 1
   lea rsi, [quebra_Linha]
   mov rdx, 1
   syscall

   jmp fim

limpabuffer:

   ; Fica lendo em loop byte por byte, até encontrar o 
   ; \n e em seguida mostrar mensagem de erro e encerrar
   mov rax, 0
   mov rdi, 0
   lea rsi, [byteDescarte]
   mov rdx, 1
   syscall

   cmp byte [byteDescarte], 10 ; 10 = \n
   je mensagemErro

   jmp limpabuffer

loop:
   
   ; faz uma comparação para ver se a conjectura de collatz
   ; chegou em 1, ou seja, seu fim
   cmp qword [valorOperador], 1
   je parteFinal

   ; Divide o valor por 2, para verificar se o resto é 1(ímpar) ou 0(par)
   mov rax, [valorOperador]
   xor rdx, rdx
   mov rbx, 2
   div rbx

   cmp rdx, 0 ; número par
   je .par

   jmp .impar ; número ímpar

   .par: ; n = n / 2 
      mov [valorOperador], rax
      inc byte [contador]
      jmp loop


   .impar: ; n = 3n + 1
      mov rax, [valorOperador]
      imul rax, 3
      inc rax
      inc byte [contador]

      mov [valorOperador], rax
      jmp loop

; etapa de escrever no arquivo
parteFinal:

   ; abertura do arquivo
   mov rax, 2                  
   lea rdi, [nomeArquivo]      
   mov rsi, 1089 ; esse valor resulta na soma de 3 flags: write, create, append(adiciona no fim)               
   mov rdx, 0x1B6 ; permissão necessária
   syscall

   mov r12, rax ; armazena o descritor do arquivo, para escrever nele depois

   ; etapa que transforma o valor de passos em ASCII
   ; é realizado uma comparação para ver se
   ; o número de passos é maior que 99, ou seja, 3 digitos
   cmp byte [contador], 99
   jbe .passos_Menor_99 ; se menor ou igual 

   jmp .passos_Maior_100

   .passos_Menor_99:

      ; Também realiza notação posicional, dessa vez inversa
      ; exemplo: n = 57: 57/10 quociente = 5 e resto = 7
      mov rax, [contador]
      mov rbx, 10
      xor rdx, rdx
      div rbx
      ; rax = quociente e rdx = resto

      ; transforma em ASCII
      add rax, '0'
      add rdx, '0'

      ; armazena numa vetor os caracteres do contador
      mov [contador_Em_ASCII], al
      mov [contador_Em_ASCII + 1], dl

      ; r15b recebe 2 para auxiliar na escrita do final
      mov r15b, 2

      jmp .escrita_Arquivo

   .passos_Maior_100:

      ; Da mesma forma também realiza notação posicional, 
      ; inversa mas com 2 iteração por ser de 3 digitos
      ; exemplo: n = 139: 139/10 quociente = 13 e resto = 9
      ; 2a iteração n = 13: 13/10 quociente = 1 e resto = 3
      mov rax, [contador]
      mov rbx, 10
      xor rdx, rdx
      div rbx

      add rdx, '0'      
      mov [contador_Em_ASCII + 2], dl ; armazena o 3o digito

      xor rdx, rdx
      div rbx

      ; transforma em ASCII
      add rax, '0'
      add rdx, '0'

      mov [contador_Em_ASCII + 1], dl ; armazena o 2o digito
      mov [contador_Em_ASCII], al ; armazena o 1o digito

      ; r15b recebe 3 para auxiliar na escrita do final
      mov r15b, 3

      jmp .escrita_Arquivo

   .escrita_Arquivo:

      ; syscalls para escrever no arquivo da seguinte maneira:
      ; Número de entrada: X -> Quantidade de Passos: Y

      ; printa: Número de entrada:
      mov rax, 1
      mov rdi, r12 ; descritor do arquivo
      lea rsi, [strNumero]        
      mov rdx, strNumero_Len      
      syscall

      ; printa: X
      mov rax, 1
      mov rdi, r12 
      lea rsi, [valorEntrada]        
      mov rdx, r13      
      syscall

      ; printa: -> Quantidade de Passos:
      mov rax, 1
      mov rdi, r12 
      lea rsi, [strPassos]        
      mov rdx, strPassos_Len      
      syscall

      ; printa: Y
      mov rax, 1
      mov rdi, r12 
      lea rsi, [contador_Em_ASCII]        
      movsx rdx, r15b      
      syscall

      ; printa \n
      mov rax, 1
      mov rdi, r12 
      lea rsi, [quebra_Linha]        
      mov rdx, 1      
      syscall

      ; fecha o arquivo
      mov rax, 3
      mov rdi, r12
      syscall

fim:

   mov rax, 60
   mov rdi, 0
   syscall
