%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
%}
%option noyywrap

%%
"func"                  { return FUNC; }                          // Palabra clave 'func'
[a-zA-Z][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return ID; } // Identificadores
[0-9]+                 { yylval.str = strdup(yytext); return ID; } // Números como identificadores
"("                    { return PARIZQ; }                        // Paréntesis izquierdo
")"                    { return PARDER; }                        // Paréntesis derecho
";"                    { return PUNTOYCOMA; }                    // Punto y coma
","                    { return COMA; }                          // Coma
[ \t\n]+              ;                                          // Ignorar espacios en blanco
.                     { return yytext[0]; }                      // Retornar cualquier otro carácter

%%