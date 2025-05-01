%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%%
"int"     { return INT; }
"func"    { return FUNC; }
"return"  { return RETURN; }
[a-zA-Z][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return ID; }
"("       { return PARIZQ; }
")"       { return PARDER; }
"{"       { return LLAVEIZQ; }
"}"       { return LLAVEDER; }
";"       { return PUNTOYCOMA; }
","       { return COMA; }
"="       { return IGUAL; }
[ \t\n]+  ; /* Ignorar espacios */
.         { return yytext[0]; }
%%

int yywrap(void) {
    return 1;
}