%{
#include <stdio.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>
#include "parser.tab.c" // Archivo de encabezado generado por Bison
#define EXIT_ERROR -1 // Definición de un token de error

void error(char *elemento, int longitudElemento); // Declaración de la función de manejo de errores
%}

option noyywrap
espacios        [ \t\n\r]+
identificador   [a-zA-Z][a-zA-Z0-9]{0,31}
constante       [0-9]+

%%

"inicio"        { yylval.reservada = strdup(yytext); return INICIO; }
"fin"           { yylval.reservada = strdup(yytext); return FIN; }
"leer"          { yylval.reservada = strdup(yytext); return LEER; }
"escribir"      { yylval.reservada = strdup(yytext); return ESCRIBIR; }
":="            { return ASIGNACION; }
{constante}     { yylval.entero = atoi(yytext); return CONSTANTE; }
{identificador} { yylval.identificador = strdup(yytext); return ID; }
{espacios}      ; // Saltar espacios en blanco
.               { error(yytext, yyleng); return EXIT_ERROR; } // Caracteres no válidos

%%

// Función para manejar errores léxicos
void error(char *elemento, int longitudElemento) {
    // Imprimir información de error con número de línea y posición
    fprintf(stderr, "Error en la línea %d, posición %d: ", yylineno, (int)(elemento - yytext + 1));

    // Verificar si el elemento podría ser un identificador
    if (isalpha(elemento[0]) && longitudElemento > 1) {
        // Verificar la longitud máxima permitida para identificadores
        if (longitudElemento > 32) {
            fprintf(stderr, "Longitud del identificador excedida (máximo 32 caracteres).\n");
        } else {
            // Verificar que todos los caracteres subsiguientes sean alfanuméricos
            for (int i = 1; i <= longitudElemento; i++) {
                if (!isalnum(elemento[i])) {
                    fprintf(stderr, "Carácter no válido en la posición %d.\n", i + 1);
                    return;
                }
            }
        }
    } else {
        // Manejar casos donde el elemento no es un identificador válido
        if (longitudElemento == 1) {
            fprintf(stderr, "Carácter no válido para identificadores o constantes.\n");
        } else {
            fprintf(stderr, "El identificador comienza con un caracter inválido.\n");
        }
    }
}

int main() {
    yylex();
    return 0;
}