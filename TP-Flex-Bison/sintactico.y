%{
	#include <stdio.h>
	int yylex();
	int yyerror(char *s);
%} 

%token INICIO FIN LEER ESCRIBIR ADICION RESTA ASIGNACION FINSENTENCIA COMA APERTURAPARENTESIS CIERREPARENTESIS CONSTANTE ID FDT

//Revisar tipo entero como unico tipo en micro
/*
%union {
	int constante
	char *identificador
	char *reservada;
}

%type <>
*/

%%

//Revisar recursividad en bison
objetivo: 
	PROGRAMA FDT
;

PROGRAMA: INICIO LISTASENTENCIAS FIN

LISTASENTENCIAS: SENTENCIA LISTASENTENCIAS

SENTENCIA: ID ASIGNACION EXPRESION PUNTOYCOMA
		  |LEER PARENIZQUIERDO LISTAIDENTIFICADORES PARENDERECHO PUNTOYCOMA
		  |ESCRIBIR PARENIZQUIERDO LISTAEXPRESIONES PARENDERECHO PUNTOYCOMA

LISTAIDENTIFICADORES: ID | ID COMA LISTAIDENTIFICADORES

LISTAEXPRECIONES: EXPRESION | EXPRESION COMA LISTAEXPRESIONES

EXPRESION: PRIMARIA OPERADOR PRIMARIA

PRIMARIA: ID | CONSTANTE | PARENIZQUIERDO EXPRESION PARENDERECHO

OPERADOR: ADICION | RESTA
