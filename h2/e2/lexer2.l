%{
#include <stdio.h>
#include <string.h>
%}

%option noyywrap

/* Estados para manejar comentarios y cadenas */
%x COMENTARIO_LINEA
%x COMENTARIO_BLOQUE
%x ESTADO_CADENA

/* Definiciones */
DIGITO    [0-9]
LETRA     [a-zA-Z]
ID        {LETRA}({LETRA}|{DIGITO}|_)*
NUMERO    {DIGITO}+(\.{DIGITO}+)?([eE][+-]?{DIGITO}+)?
OPERADOR  [\+\-\*\/\=\<\>\!\&\|\^\%]

%%
"int"      { printf("PALABRA_CLAVE: %s\n", yytext); }
"return"   { printf("PALABRA_CLAVE: %s\n", yytext); }

{ID}       { printf("IDENTIFICADOR: %s\n", yytext); }
{NUMERO}   { printf("NUMERO: %s\n", yytext); }
{OPERADOR} { printf("OPERADOR: %s\n", yytext); }

"//"      { BEGIN(COMENTARIO_LINEA); printf("INICIO_COMENTARIO_LINEA\n"); }
<COMENTARIO_LINEA>\n { BEGIN(INITIAL); printf("FIN_COMENTARIO_LINEA\n"); }
<COMENTARIO_LINEA>.  { /* Ignorar el contenido del comentario */ }

"/*"      { BEGIN(COMENTARIO_BLOQUE); printf("INICIO_COMENTARIO_BLOQUE\n"); }
<COMENTARIO_BLOQUE>"*/" { BEGIN(INITIAL); printf("FIN_COMENTARIO_BLOQUE\n"); }
<COMENTARIO_BLOQUE>.|\n { /* Ignorar el contenido del comentario */ }

\"        { BEGIN(ESTADO_CADENA); printf("INICIO_CADENA\n"); }
<ESTADO_CADENA>\"    { BEGIN(INITIAL); printf("FIN_CADENA\n"); }
<ESTADO_CADENA>\\\"  { printf("ESCAPE_COMILLA\n"); }
<ESTADO_CADENA>\\n   { printf("ESCAPE_SALTO\n"); }
<ESTADO_CADENA>.     { printf("CARACTER_CADENA: %s\n", yytext); }

[ \t\n]    { /* Ignorar espacios en blanco */ }
.          { printf("OTRO: %s\n", yytext); }
%%

int main() {
    yylex();
    return 0;
}