# Guia de GDB para Linguagem de Montagem (x86-64)

Referência de comandos GDB para debug de programas em Assembly (NASM): breakpoints, registradores, memória, variáveis e flags.

---

## 1. Compilando com símbolos de debug

Para ter acesso a nomes de variáveis e melhor suporte do GDB, monte com `-g`:

```bash
nasm -f elf64 -g -F dwarf programa.asm -o programa.o
ld programa.o -o programa.x
gdb ./programa.x
```

Sem símbolos, o GDB ainda funciona, mas você precisa trabalhar com endereços de memória em vez de nomes de variáveis (seção 5).

---

## 2. Breakpoints e execução

| Comando | Função |
|---|---|
| `b nome_label` | breakpoint num rótulo (ex: `b main`) |
| `b *0x401030` | breakpoint num endereço absoluto |
| `r` | inicia o programa (`run`) |
| `c` | continua a execução (`continue`) |
| `si` / `stepi` | executa **uma instrução de máquina**, entrando em calls |
| `ni` / `nexti` | executa uma instrução, **pulando** por cima de calls |
| `disassemble` | mostra o assembly da função atual |
| `disassemble /r` | idem, com os opcodes em hexadecimal |
| `info breakpoints` | lista os breakpoints ativos |
| `delete N` | remove o breakpoint N |

Para Assembly puro, prefira `si`/`ni` a `step`/`next` (pensados para código C).

---

## 3. Registradores

### Visualizar
```
i r            # todos os registradores
i r ax bx      # registradores específicos
i r rax        # versão 64 bits
i r eflags     # flags de status
```

### Tamanhos no `print`
No `print`, o tamanho vem do **nome do registrador**, não de sufixo:
```
p $al     # 8 bits (baixo)
p $ah     # 8 bits (alto)
p $ax     # 16 bits
p $eax    # 32 bits
p $rax    # 64 bits
```

### Formatos de exibição
```
p/x $ax    # hexadecimal
p/t $ax    # binário
p/o $ax    # octal
p/d $ax    # decimal com sinal
p/u $ax    # decimal sem sinal
p/c $ax    # caractere
```
`print` avalia uma expressão por vez — para múltiplos registradores, repita o comando ou combine com operadores (`p $ax + $bx`).

---

## 4. EFLAGS — principais flags

| Flag | Nome | Significado |
|---|---|---|
| `CF` | Carry Flag | vai-um / empresta (aritmética sem sinal) |
| `ZF` | Zero Flag | resultado foi zero |
| `SF` | Sign Flag | resultado negativo (bit mais significativo = 1) |
| `OF` | Overflow Flag | estouro em aritmética **com sinal** |
| `PF` | Parity Flag | número par de bits 1 no byte menos significativo |
| `AF` | Auxiliary Flag | vai-um entre nibbles (usado em BCD) |
| `IF` | Interrupt Flag | interrupções mascaráveis habilitadas |

Útil para conferir carry/overflow logo após instruções aritméticas (`add`, `sub`, `cmp`, `inc`, `dec`).

---

## 5. Memória e variáveis (`x` — examine)

Sintaxe: `x/NFU endereço`
- **N** = quantidade de unidades a exibir
- **F** = formato: `x`(hex), `d`(decimal), `t`(binário), `u`(unsigned), `c`(char), `i`(instrução), `s`(string)
- **U** = tamanho da unidade: `b`(byte), `h`(halfword=2B), `w`(word=4B), `g`(giant=8B)

```
x/1xb &v1      # 1 byte em hex
x/1tw &v1      # 1 word (4 bytes) em binário
x/4xb &v1      # 4 bytes em hex, um a um
x/s &msg       # string terminada em \0
x/3i $pc       # próximas 3 instruções a partir do PC
```

`x` trabalha com **endereços** (por isso o `&` antes de variáveis de memória). Registradores não têm endereço — para ver o conteúdo deles em qualquer formato, use `print` (`p/t $ax`, `p/x $bx` etc).

### Descobrindo endereços sem símbolos
```bash
nm programa.x | grep v1
objdump -t programa.x | grep v1
```
e então acesse direto pelo endereço: `x/xb 0x402000`.

---

## 6. Comandos de conveniência

```
display $ax           # mostra $ax automaticamente a cada parada
display/t $bx          # idem, em binário
undisplay 1             # remove um display
watch v1                # pausa quando v1 mudar de valor
watch $ax                # pausa quando o registrador mudar (watchpoint de hardware)
layout regs              # (modo TUI) registradores + código lado a lado
layout asm                 # (modo TUI) só o assembly
Ctrl+X depois 2             # ativa/alterna o layout de registradores
```

`layout regs` é especialmente útil nessa matéria: os registradores atualizam em tempo real a cada `si`.

---

## 7. Fluxo típico de debug

1. `b rotulo` nos pontos de interesse
2. `r` para iniciar
3. `layout regs` (opcional, visão contínua dos registradores)
4. `si`/`ni` para avançar instrução a instrução
5. `i r` / `p/x $reg` para conferir valores
6. `i r eflags` após operações aritméticas ou lógicas, para ver os flags resultantes
7. `x/...` para inspecionar variáveis em memória
8. `c` para pular para o próximo breakpoint


# Tamanhos de Dados em NASM (x86-64)

Referência rápida de tamanhos, diretivas de declaração e reserva de memória.

---

## 1. Tamanhos fundamentais

| Nome | Bits | Bytes | Faixa sem sinal | Faixa com sinal |
|---|---|---|---|---|
| byte | 8 | 1 | 0 a 255 | −128 a 127 |
| word | 16 | 2 | 0 a 65.535 | −32.768 a 32.767 |
| double word (dword) | 32 | 4 | 0 a ~4,29 bilhões | ~−2,14 bi a ~2,14 bi |
| quad word (qword) | 64 | 8 | 0 a 2⁶⁴−1 | −2⁶³ a 2⁶³−1 |

O nome "word" = 16 bits vem do 8086 e ficou fixo por compatibilidade, mesmo em máquinas de 64 bits.

---

## 2. Declarar dados inicializados — seção `.data`

Diretivas `d*` (**d**efine): reservam espaço **e** já colocam um valor.

| Diretiva | Tamanho | Exemplo |
|---|---|---|
| `db` | 1 byte | `v1 db 0xFF` |
| `dw` | 2 bytes | `v2 dw 1234` |
| `dd` | 4 bytes | `v3 dd 100000` |
| `dq` | 8 bytes | `v4 dq 0x1122334455667788` |
| `dt` | 10 bytes | `v5 dt 3.1415` (float estendido x87) |

```nasm
section .data
    contador   dd  0
    limite     dw  100
    letra      db  'A'
    msg        db  'Ola mundo', 10, 0     ; string + \n + terminador
    vetor      dd  1, 2, 3, 4             ; 4 dwords consecutivos
    zeros      db  10 dup(0)              ; 10 bytes com valor 0
```

`dup` repete um valor N vezes. Em strings, cada caractere ocupa 1 byte, então sempre `db`.

---

## 3. Reservar espaço não inicializado — seção `.bss`

Diretivas `res*` (**res**erve): reservam espaço sem valor inicial (o SO zera na carga). O operando é a **quantidade de unidades**, não de bytes.

| Diretiva | Tamanho de cada unidade |
|---|---|
| `resb` | 1 byte |
| `resw` | 2 bytes |
| `resd` | 4 bytes |
| `resq` | 8 bytes |
| `rest` | 10 bytes |

```nasm
section .bss
    buffer   resb 64      ; 64 bytes
    numeros  resd 10      ; 10 dwords = 40 bytes
    total    resq 1       ; 1 qword = 8 bytes
```

Diferença prática: `.data` vai gravado dentro do executável (ocupa espaço no arquivo), `.bss` só reserva espaço em tempo de execução.

---

## 4. Registradores e seus tamanhos

| 64 bits | 32 bits | 16 bits | 8 bits (baixo) | 8 bits (alto) |
|---|---|---|---|---|
| `rax` | `eax` | `ax` | `al` | `ah` |
| `rbx` | `ebx` | `bx` | `bl` | `bh` |
| `rcx` | `ecx` | `cx` | `cl` | `ch` |
| `rdx` | `edx` | `dx` | `dl` | `dh` |
| `rsi` | `esi` | `si` | `sil` | — |
| `rdi` | `edi` | `di` | `dil` | — |
| `rsp` | `esp` | `sp` | `spl` | — |
| `rbp` | `ebp` | `bp` | `bpl` | — |
| `r8`–`r15` | `r8d`–`r15d` | `r8w`–`r15w` | `r8b`–`r15b` | — |

São a **mesma área física**: escrever em `al` altera o byte baixo de `rax`.

Detalhe importante do x86-64: escrever num registrador de 32 bits **zera automaticamente** os 32 bits superiores (`mov eax, 5` → `rax = 5`). Escrever em 16 ou 8 bits **não** zera o resto.

---

## 5. Especificadores de tamanho em instruções

Quando o tamanho não é dedutível pelos operandos, é preciso declarar explicitamente:

```nasm
mov  [v1], 5           ; ERRO: ambíguo, quantos bytes?
mov  byte  [v1], 5     ; escreve 1 byte
mov  word  [v2], 5     ; escreve 2 bytes
mov  dword [v3], 5     ; escreve 4 bytes
mov  qword [v4], 5     ; escreve 8 bytes

mov  al, [v1]          ; OK: al define que é 1 byte
mov  eax, [v3]         ; OK: eax define que são 4 bytes
```

Palavras-chave de tamanho: `byte`, `word`, `dword`, `qword`, `tword`.

---

## 6. Conversão entre tamanhos

```nasm
movzx eax, byte [v1]   ; zero-extend: preenche o resto com 0 (sem sinal)
movsx eax, byte [v1]   ; sign-extend: replica o bit de sinal (com sinal)
movsxd rax, eax        ; estende 32 → 64 bits com sinal
```

Instruções sem operando que estendem o acumulador (usadas antes de divisão com sinal):

| Instrução | Efeito |
|---|---|
| `cbw` | `al` → `ax` |
| `cwde` | `ax` → `eax` |
| `cdqe` | `eax` → `rax` |
| `cwd` | `ax` → `dx:ax` |
| `cdq` | `eax` → `edx:eax` |
| `cqo` | `rax` → `rdx:rax` |

---

## 7. Little-endian

O x86 armazena o **byte menos significativo primeiro**. Declarando:

```nasm
v dd 0x12345678
```

a memória fica: `78 56 34 12`

Por isso, ao inspecionar byte a byte no GDB (`x/4xb &v`) a ordem aparece invertida em relação ao valor escrito no código. Lendo com o tamanho correto (`x/1xw &v`) o valor aparece normal.

---

## 8. Alinhamento

Acessos alinhados (endereço múltiplo do tamanho) são mais rápidos e, em algumas instruções SIMD, obrigatórios.

```nasm
section .data
    align 8
    valor dq 0
```

`align N` insere preenchimento até o próximo múltiplo de N.

#### Nota: Conteúdo gerado por IA.