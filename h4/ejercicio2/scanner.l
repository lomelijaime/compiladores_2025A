%{
#include "parser.tab.h" // Inclusión del archivo de encabezado generado
#include <string.h>     // Para funciones de manipulación de cadenas
#include <stdlib.h>     // Para funciones de asignación dinámica
%}
%option noyywrap        // Evita problema macos

%%
"int"                   { return INT; }        // Reconoce palabra clave int
[a-zA-Z][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return ID; }  // Captura identificadores
"="                     { return IGUAL; }      // Reconoce operador de asignación
";"                     { return PUNTOYCOMA; } // Reconoce punto y coma
[ \t\n]+               ;                      // Ignora espacios en blanco
.                      { return yytext[0]; }  // Cualquier otro carácter

%%