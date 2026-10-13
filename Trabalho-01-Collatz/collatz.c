#include <stdio.h>

int main()
{
    int entrada;

    FILE *arquivo;
    arquivo = fopen("collatz_um_de_cada.txt", "a");

    printf("Digite um valor de um ou dois digitos: ");
    scanf("%d", &entrada);

    if (entrada == 0)
    {
        printf("Erro\n");
        return 0;
    }
    else if (entrada >= 100)
    {
        printf("Erro\n");
        return 0;
    }
    else
    {
        printf("Passou\n");

        int itaracoes = 0;
        int collatz = entrada;

        while (collatz != 1)
        {
            if (collatz % 2 == 0)
            {
                collatz = collatz / 2;
            }
            else
            {
                collatz = (3 * collatz) + 1;
            }
            itaracoes += 1;
        }

    fprintf(arquivo, "Entrada: %d. Iteracoes: %d.\n", entrada, itaracoes);

    fclose(arquivo);    }
    return 0;
}
