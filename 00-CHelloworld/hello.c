#include <stdio.h>

int main() 
{
    // Abro el archivo "output.txt" en modo escritura, que redirigirá el stdout al archivo
    FILE *archivo = freopen("output.txt", "w", stdout);
    
    if (archivo == NULL) 
    {
        printf("No se pudo abrir el archivo output.txt\n");
        return 1;
    }

    // Imprimir en stdout, que ahora está redirigido al archivo "output.txt"
    printf("World!\n");

    // Cierro el archivo
    fclose(archivo);

    return 0;
}
