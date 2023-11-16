%{

#include <stdio.h>
#include <stdlib.h>
int yylex();
int yyerror(char *s);

%}

%union {
    int entero;
    char *identificador;
    char *reservada;
    //char *entero;
}

%token <entero> CONSTANTE
%token <identificador> ID 
%token <reservada> INICIO FIN LEER ESCRIBIR ADICION RESTA ASIGNACION PUNTOYCOMA COMA PARENIZQUIERDO PARENDERECHO FDT

%type <reservada> PROGRAMA LISTASENTENCIAS SENTENCIA LISTAEXPRESIONES EXPRESION PRIMARIA

%nonassoc LISTAIDENTIFICADORES

%%

objetivo: PROGRAMA FDT { printf("Análisis sintáctico exitoso.\n"); };
        // | error FDT { fprintf(stderr, "Error: Análisis sintáctico fallido.\n"); exit(EXIT_FAILURE); }

PROGRAMA: INICIO LISTASENTENCIAS FIN;

LISTASENTENCIAS: SENTENCIA
               | LISTASENTENCIAS SENTENCIA;

SENTENCIA: ID ASIGNACION EXPRESION PUNTOYCOMA { printf("Asignación de valor a la variable %s.\n", $1); }
         | LEER PARENIZQUIERDO LISTAIDENTIFICADORES PARENDERECHO PUNTOYCOMA
         | ESCRIBIR PARENIZQUIERDO LISTAEXPRESIONES PARENDERECHO PUNTOYCOMA;

LISTAIDENTIFICADORES: ID 
                    | LISTAIDENTIFICADORES COMA ID;

LISTAEXPRESIONES: EXPRESION
                | LISTAEXPRESIONES COMA EXPRESION;

EXPRESION: PRIMARIA OPERADOR PRIMARIA;

PRIMARIA: ID
        | CONSTANTE
        | PARENIZQUIERDO EXPRESION PARENDERECHO;

OPERADOR: ADICION
        | RESTA;

%%

int main(int argc,char **argv){
        yyparse();
        return 0;
}
