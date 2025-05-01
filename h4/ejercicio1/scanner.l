%{
#include "parser.tab.h"  // Se incluye el encabezado generado por Bison
#include <string.h>      // Para manejo de cadenas (strdup)
#include <stdlib.h>      // Para funciones estándar
%}
%option noyywrap
%%

"int"                   { return INT; }          // Reconoce palabra clave int
[a-zA-Z][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return ID; }  // Reconoce identificadores
";"                     { return PUNTOYCOMA; }   // Reconoce punto y coma
[ \t\n]+               ;                         // Ignora espacios en blanco
.                      { return yytext[0]; }     // Reconoce cualquier otro caracter

%%
