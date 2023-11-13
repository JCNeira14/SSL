%{
	#include <stdio.h>
	#include <string.h>
	#include "sintactico.tab.h"
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

.				{error(); return (ERROR);}

%%

/*
Error de identificador: Caracter erroneo, longitud excedida, empieza con numero.
*/
void error (char * otro){
	printf("<<Error lexico: "%s" >>", otro)
}

