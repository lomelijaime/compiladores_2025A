%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(char *s) {
    printf("Error: %s\n", s);
    return 0;
}

#define MAX_FUNC 100  // Número máximo de funciones soportadas

char *funciones[MAX_FUNC];  // Arreglo para nombres de funciones
int aridades[MAX_FUNC];     // Arreglo para número de argumentos esperados
int nfuncs = 0;            // Contador de funciones registradas

void registrar_funcion(char *id, int n) {
    funciones[nfuncs] = strdup(id);  // Guarda el nombre de la función
    aridades[nfuncs++] = n;          // Guarda su aridad
}

int obtener_aridad(char *id) {
    for (int i = 0; i < nfuncs; i++)
        if (strcmp(funciones[i], id) == 0)
            return aridades[i];       // Devuelve aridad
    return -1;                       // Retorna -1 si no está definida
}

%}

%union {
    char *str;
    int num;
}

%token <str> ID           // Token para identificadores
%token FUNC PARIZQ PARDER PUNTOYCOMA COMA

%type <num> lista        // Tipo para contar parámetros en declaración
%type <num> args         // Tipo para contar argumentos en llamada

%%

programa: declaraciones llamadas    
        ;

declaraciones: FUNC ID PARIZQ lista PARDER PUNTOYCOMA {
                registrar_funcion($2, $4);
             }
           | declaraciones FUNC ID PARIZQ lista PARDER PUNTOYCOMA {
                registrar_funcion($3, $5);
             }
           ;

lista: ID                  { $$ = 1; }        // Una variable como parámetro
    | lista COMA ID        { $$ = $1 + 1; }   // Más de un parámetro
    ;

llamadas: llamada
        | llamadas llamada
        ;

llamada: ID PARIZQ args PARDER PUNTOYCOMA {
            int n = obtener_aridad($1);      // Busca cuántos parámetros espera
            if (n != $3)                    // Compara con número de argumentos dados
                printf("Error: se esperaban %d argumentos en '%s'\n", n, $1);
        }
        ;

args: /* vacío */            { $$ = 0; }        // Sin argumentos
    | ID                     { $$ = 1; }        // Un argumento
    | args COMA ID           { $$ = $1 + 1; }   // Más de un argumento
    ;

%%

int main() {
    return yyparse();
}