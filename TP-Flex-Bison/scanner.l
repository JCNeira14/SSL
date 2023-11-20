%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "parser.tab.h"
extern int yylineno;
#define EXIT_ERROR -1

int yylineno = 1;
int yylex(void);
void especificarError(char *elemento, int longitudElemento);
%}
%option noyywrap

espacios        [\t\n\r]
identificador   [a-zA-Z][a-zA-Z0-9]{0,31}
constante       [0-9]+
%%

"inicio"        { yylval.reservada = strdup(yytext); return INICIO; }
"fin"           { yylval.reservada = strdup(yytext); return FIN; }
"leer"          { yylval.reservada = strdup(yytext); return LEER; }
"escribir"      { yylval.reservada = strdup(yytext); return ESCRIBIR; }
"("             return '(';
")"             return ')';
","             return ',';
"+"             return '+';
"-"             return '-';
";"             return ';';
":="            { return ASIGNACION; }
{constante}     { yylval.constante = atoi(yytext); return CONSTANTE; }
{identificador} { yylval.identificador = strdup(yytext); return ID; }
{espacios}      ; // Saltar espacios en blanco
.               { especificarError(yytext, yyleng); return EXIT_ERROR; } // Caracteres no válidos

%%

// Función para manejar errores léxicos
void especificarError(char *elemento, int longitudElemento) {
    // Imprimir información de especificarError con número de línea y posición
    fprintf(stderr, "Error en la línea %d: %s\n", yylineno, elemento);

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
    }else{
        // Manejar casos donde el elemento no es un identificador válido
        if (longitudElemento == 1) {
            if (isalnum(elemento[0])){
            fprintf(stderr, "Primer carácter no válido para identificadores o constantes.\n");
            }
        } else {
            fprintf(stderr, "El identificador comienza con un caracter especial.\n");
        }
    }
}

/* este codigo sirve para compilar con flex y ver si reconoce los tokens
int main(int argc, char **argv) {
    int token;
    while ((token = yylex())) {
        switch (token) {
            case INICIO:
            case FIN:
            case LEER:
            case ESCRIBIR:
            case '(':
            case ')':
            case ',':
            case '+':
            case '-':
            case ';':
            case ASIGNACION:
            case CONSTANTE:
            case ID:
                printf("Token: %d, Lexema: %s\n", token, yytext);
                break;
            default:
                printf("Token: %d\n", token);
        }
    }
    return 0;
}
*/