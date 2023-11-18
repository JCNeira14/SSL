%{

#include <stdio.h>
#include <stdlib.h>
int yylex();
//int yyerror(char *s);

%}
%token INICIO FIN LEER ESCRIBIR ASIGNACION CONSTANTE ID
%%

objetivo: PROGRAMA { printf("Análisis sintáctico exitoso.\n"); };
        // | error { fprintf(stderr, "Error: Análisis sintáctico fallido.\n"); exit(EXIT_FAILURE); }

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

int main(int argc,char **argv){
        yyparse();
        return 0;
}
