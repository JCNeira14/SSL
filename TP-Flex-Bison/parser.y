%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylex();
int yyerror(char *s);

%}

%union {
        int constante;
        char *identificador;
        char *reservada;
}

%token <reservada> INICIO FIN LEER ESCRIBIR
%token <constante> CONSTANTE
%token <identificador> ID
%token ASIGNACION

%start PROGRAMA

%%
PROGRAMA: INICIO LISTASENTENCIAS FIN;

LISTASENTENCIAS:
        | SENTENCIA LISTASENTENCIAS;

SENTENCIA: ID ASIGNACION EXPRESION ';' { printf("Asignación de valor a la variable %s.\n", $1); }
        | LEER '(' LISTAIDENTIFICADORES ')' ';' { printf("Lectura de variables\n"); }
        | ESCRIBIR '(' LISTAEXPRESIONES ')' ';' { printf("Escritura de expresiones\n"); }
        ;

LISTAIDENTIFICADORES: ID
        | LISTAIDENTIFICADORES ',' ID;

LISTAEXPRESIONES: EXPRESION
        | LISTAEXPRESIONES ',' EXPRESION;

EXPRESION: PRIMARIA
        | PRIMARIA '+' PRIMARIA
        | PRIMARIA '-' PRIMARIA;

PRIMARIA: ID
        | CONSTANTE
        | '(' EXPRESION ')';
%%

int main()
{
        if (yyparse() == 0)
                printf("Analisis Sintactico exitoso.\n");
        return 0;
}

int yyerror(char* mensaje)
{
        fprintf(stderr,"Error Sintactico: %s\n", mensaje);
        return 1;
}
