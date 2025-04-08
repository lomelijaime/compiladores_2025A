%{
#include <stdio.h>
%}

/* Definiciones */
DIGITO    [0-9]
LETRA     [a-zA-Z]
ID        {LETRA}({LETRA}|{DIGITO}|_)*
NUMERO    {DIGITO}+(\.{DIGITO}+)?([eE][+-]?{DIGITO}+)?

%%
"int"      { printf("PALABRA_CLAVE: %s\n", yytext); }
"return"   { printf("PALABRA_CLAVE: %s\n", yytext); }
{ID}       { printf("IDENTIFICADOR: %s\n", yytext); }
{NUMERO}   { printf("NUMERO: %s\n", yytext); }
[ \t\n]    { /* Ignorar espacios en blanco */ }
.          { printf("OTRO: %s\n", yytext); }
%%

int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}