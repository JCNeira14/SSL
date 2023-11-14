%{
	#include <stdio.h>
	#include <string.h>
	#include "sintactico.tab.h"
	#include <ctype.h>
	void error();
%}

identificador	[a-zA-z][a-zA-Z0-9]{0-30}
constante		[0-9]+
digito 			[0-9]
letra			[a-zA-Z]

%%

"inicio"		{yylval.reservada = yytext; return (INICIO);}
"fin"			{yylval.reservada = yytext; return (FIN);}
"leer"			{yylval.reservada = yytext; return (LEER);}
"escribir"		{yylval.reservada = yytext; return (ESCRIBIR);}
"+"				{return (ADICION);}
"-"				{return (RESTA);}
":="			{return (ASIGNACION);}
";"				{return (FINSENTENCIA);}
","				{return (COMA);}
"("				{return (APERTURAPARENTESIS);}
")"				{return (CIERREPARENTESIS);}
{constante}		{yylval.constante = atoi(yytext); return (CONSTANTE);}
{identificador}	{yylval.identificador = yytext; return (ID);}

.				{error(yytext, yylen); return (ERROR);}

%%

void error(char *elemento, int longitudElemento) {
	//longitudElemento = strlen(elemento);

	// Verificar si intenta ser un identificador
    if (isalpha(elemento[0]) && longitudElemento > 1) {
		if (longitudElemento > 32) {
			printf("Error: Longitud del identificador excedida (máximo 32 caracteres).\n");
			return;
		}

		// Verificar el resto de los caracteres son letras
		for (int i = 1; i <= longitudElemento; i++) {
			if (!isalnum(elemento[i])) {
					printf("Error: Carácter no válido en la posición %d.\n", i + 1);
					return;
				}
			}
	}
	else {
		if longitudElemento == 1{
			printf("Error: Carácter no válido para identificadores o constantes.\n");
			return;
		}
		else {
			printf("Error: El identificador comienza con un caracter invalido.\n");
			return;
		}
	}
}
