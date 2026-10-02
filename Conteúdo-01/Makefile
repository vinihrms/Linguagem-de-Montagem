NASM = nasm
LD = ld
FLAGS_NASM = -f elf64 -g -F dwarf

# Alvo padrão quando você digita apenas 'make'
all:
	@echo "Por favor, especifique o arquivo. Exemplo:"
	@echo "make run arq=meu_arquivo"
	@echo "make debug arq=meu_arquivo"

# Compila e executa direto
run: $(arq)
	./$(arq)

# Compila e abre no gdb
debug: $(arq)
	gdb ./$(arq)

# Regra de compilação genérica
$(arq): $(arq).asm
	$(NASM) $(FLAGS_NASM) $(arq).asm -o $(arq).o
	$(LD) $(arq).o -o $(arq)

# Limpa os arquivos gerados
clean:
	rm -f *.o $(arq)
