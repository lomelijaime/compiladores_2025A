%{
#include "parser.tab.h"  // Inclusión del encabezado generado por bison
#include <string.h>      // Para manejo de cadenas
#include <stdlib.h>      // Para asignación dinámica
%}

%option noyywrap

%%
"int"                       { return INT; }          // Palabra clave int
[a-zA-Z][a-zA-Z0-9_]*      { yylval.str = strdup(yytext); return ID; }  // Identificadores
";"                        { return PUNTOYCOMA; }   // Punto y coma
"{"                        { return LLAVEIZQ; }     // Llave izquierda
"}"                        { return LLAVEDER; }     // Llave derecha
[ \t\n]+                   ;                        // Ignora espacios en blanco
.                          { return yytext[0]; }    // Resto de caracteres
%%