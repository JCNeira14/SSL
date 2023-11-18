%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"
extern int yylex();

%}

%union {
        int constante;
        char *identificador;
        char *reservada;
        char *asignacion;
}

%token <reservada> INICIO FIN LEER ESCRIBIR
%token <constante> CONSTANTE
%token <identificador> ID
%token <asignacion> ASIGNACION

%%

objetivo: PROGRAMA { printf("Análisis sintáctico exitoso.\n"); }
        | error { fprintf(stderr, "Error: Análisis sintáctico fallido.\n"); exit(EXIT_FAILURE); }

PROGRAMA: INICIO LISTASENTENCIAS FIN;

LISTASENTENCIAS: SENTENCIA
        | LISTASENTENCIAS SENTENCIA;

SENTENCIA: ID ASIGNACION EXPRESION ';' { printf("Asignación de valor a la variable %s.\n", $1); }
        | LEER '(' LISTAIDENTIFICADORES ')' ';'
        | ESCRIBIR '(' LISTAEXPRESIONES ')' ';';

LISTAIDENTIFICADORES: ID
        | LISTAIDENTIFICADORES ',' ID;

LISTAEXPRESIONES: EXPRESION
        | LISTAEXPRESIONES ',' EXPRESION;

EXPRESION: PRIMARIA OPERADOR PRIMARIA;

PRIMARIA: ID
        | CONSTANTE
        | '(' EXPRESION ')';

OPERADOR: '+'
        | '-';

%%

int main()
{
        return(yyparse());
}

void yyerror(char* s)
{
        fprintf(stderr, "%s\n", s);
}
