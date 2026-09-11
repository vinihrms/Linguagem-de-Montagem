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


#### Nota: Conteúdo gerado por IA.