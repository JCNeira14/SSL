%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylex();
extern void yyerror(const char *s);

int yyerror(const char *msg) {
        fprintf(stderr, "Error sintáctico en la línea %d: %s\n", yylineno, msg);
        exit(EXIT_FAILURE);
}

%}

%token INICIO FIN LEER ESCRIBIR ASIGNACION CONSTANTE ID

%%

objetivo: PROGRAMA { printf("Análisis sintáctico exitoso.\n"); }
        | error { yyerror("Error en la producción objetivo."); };

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
