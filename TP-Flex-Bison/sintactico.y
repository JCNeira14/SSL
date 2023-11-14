%{
#include <stdio.h>
#include <stdlib.h>
%}

%union {
    int constante;
    char *identificador;
    char *reservada;
}

%token <entero> CONSTANTE
%token <identificador> ID
%token <reservada> INICIO FIN LEER ESCRIBIR ADICION RESTA ASIGNACION PUNTOYCOMA COMA PARENIZQUIERDO PARENDERECHO FDT

%type <entero> PROGRAMA LISTASENTENCIAS SENTENCIA LISTAEXPRESIONES EXPRESION PRIMARIA

%%

objetivo: PROGRAMA FDT { printf("Análisis sintáctico exitoso.\n"); }
         | error FDT { fprintf(stderr, "Error: Análisis sintáctico fallido.\n"); exit(EXIT_FAILURE); }

PROGRAMA: INICIO LISTASENTENCIAS FIN;

LISTASENTENCIAS: SENTENCIA
               | LISTASENTENCIAS SENTENCIA;

SENTENCIA: ID ASIGNACION EXPRESION PUNTOYCOMA
         | LEER PARENIZQUIERDO LISTAIDENTIFICADORES PARENDERECHO PUNTOYCOMA
         | ESCRIBIR PARENIZQUIERDO LISTAEXPRESIONES PARENDERECHO PUNTOYCOMA;

LISTAEXPRESIONES: EXPRESION
                | LISTAEXPRESIONES COMA EXPRESION;

EXPRESION: PRIMARIA OPERADOR PRIMARIA;

PRIMARIA: ID
        | CONSTANTE
        | PARENIZQUIERDO EXPRESION PARENDERECHO;

OPERADOR: ADICION
        | RESTA;

%%
