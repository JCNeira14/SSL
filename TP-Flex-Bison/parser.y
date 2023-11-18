%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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

%start objetivo

%%

objetivo: PROGRAMA { printf("Análisis sintáctico exitoso.\n"); }
        | error { fprintf(stderr, "Error: Análisis sintáctico fallido.\n"); exit(EXIT_FAILURE); };

PROGRAMA: INICIO { printf("Se leyo inicio: %s\n", $1); } LISTASENTENCIAS { printf("Se leyo lista sentencias \n", $1); } FIN;

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
        fprintf(stderr,"%s\n",s);
}
