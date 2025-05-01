%{
#include <stdio.h>    // Para entrada/salida estándar
#include <stdlib.h>   // Para funciones estándar
#include <string.h>   // Para manejo de cadenas

#define MAX_ID 100    // Tamaño máximo de tabla de símbolos

char *tabla[MAX_ID];  // Arreglo para almacenar identificadores
int ntabla = 0;      // Número actual de identificadores

int yylex(void);     // Prototipo de función léxica

int yyerror(char *s) {
    printf("Error: %s\n", s);
    return 0;
}

// Agrega un identificador a la tabla si no está presente
void agregar(char *id) {
    for (int i = 0; i < ntabla; i++) {
        if (strcmp(tabla[i], id) == 0) return;  // No agrega si ya está declarado
    }
    tabla[ntabla++] = strdup(id);              // Agrega nuevo identificador
}

// Busca un identificador en la tabla
int buscar(char *id) {
    for (int i = 0; i < ntabla; i++) {
        if (strcmp(tabla[i], id) == 0) return 1;  // Retorna 1 si existe
    }
    return 0;                                     // Retorna 0 si no existe
}
%}

%union {
    char *str;
}

%token <str> ID      // Token ID asociado a cadena
%token INT           // Token para palabra clave int
%token PUNTOYCOMA    // Token para punto y coma ;

%%

programa: declaraciones usos  // Un programa son declaraciones seguidas de usos
        ;

declaraciones: INT ID PUNTOYCOMA {
                agregar($2);         // Registra una declaración
            }
            | declaraciones INT ID PUNTOYCOMA {
                agregar($3);         // Registra declaraciones adicionales
            }
            ;

usos: ID PUNTOYCOMA {
        if (!buscar($1)) {
            printf("Error semántico: '%s' no está declarado\n", $1);
        }
    }
    | usos ID PUNTOYCOMA {
        if (!buscar($2)) {
            printf("Error semántico: '%s' no está declarado\n", $2);
        }
    }
    ;

%%

int main() {
    return yyparse();  // Función principal que inicia el análisis
}