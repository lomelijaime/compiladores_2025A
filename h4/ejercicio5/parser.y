%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(char *s) { printf("Error: %s\n", s); return 0; }

#define MAX_SIMB 200

typedef struct {
    char *nombre;
    int tipo;      // 0 para variable, 1 para función
    int aridad;    // Número de argumentos si es función
    int ambito;    // Nivel de ámbito
} Simbolo;

Simbolo tabla[MAX_SIMB];
int ntabla = 0;
int ambito_actual = 0;

void entrar_ambito() { 
    ambito_actual++; 
}

void salir_ambito() {
    for (int i = 0; i < ntabla; i++) {
        if (tabla[i].ambito == ambito_actual) {
            tabla[i].nombre[0] = '\0';
        }
    }
    ambito_actual--;
}

int variable_existe_en_ambito_actual(char *id) {
    for (int i = 0; i < ntabla; i++) {
        if (tabla[i].nombre[0] != '\0' && 
            strcmp(tabla[i].nombre, id) == 0 && 
            tabla[i].tipo == 0 &&
            tabla[i].ambito == ambito_actual) {
            return 1;
        }
    }
    return 0;
}

void agregar_variable(char *id) {
    if (variable_existe_en_ambito_actual(id)) {
        printf("Error: redeclaración de '%s'\n", id);
        return;
    }
    tabla[ntabla++] = (Simbolo){strdup(id), 0, 0, ambito_actual};
}

void agregar_funcion(char *id, int aridad) {
    tabla[ntabla++] = (Simbolo){strdup(id), 1, aridad, 0};
}

int buscar_variable(char *id) {
    for (int a = ambito_actual; a >= 0; a--) {
        for (int i = 0; i < ntabla; i++) {
            if (tabla[i].nombre[0] != '\0' && 
                strcmp(tabla[i].nombre, id) == 0 && 
                tabla[i].tipo == 0 && 
                tabla[i].ambito == a)
                return 1;
        }
    }
    return 0;
}

int buscar_funcion(char *id) {
    for (int i = 0; i < ntabla; i++) {
        if (tabla[i].nombre[0] != '\0' && 
            strcmp(tabla[i].nombre, id) == 0 && 
            tabla[i].tipo == 1)
            return tabla[i].aridad;
    }
    return -1;
}
%}

%union { 
    char *str; 
    int num; 
}

%token <str> ID
%token INT FUNC RETURN IGUAL
%token PARIZQ PARDER LLAVEIZQ LLAVEDER PUNTOYCOMA COMA

%type <num> parametros lista_param argumentos lista_args

%%

programa: 
    lista_elementos
    ;

lista_elementos:
    /* vacío */
    | lista_elementos elemento
    ;

elemento:
    declaracion_variable
    | declaracion_funcion
    | asignacion
    | llamada_funcion
    ;

declaracion_variable:
    INT ID PUNTOYCOMA { 
        agregar_variable($2); 
    }
    ;

declaracion_funcion:
    FUNC ID { 
        entrar_ambito(); 
    } PARIZQ parametros PARDER {
        agregar_funcion($2, $5);
    } bloque {
        salir_ambito();
    }
    ;

bloque:
    LLAVEIZQ lista_bloque LLAVEDER
    ;

lista_bloque:
    /* vacío */
    | lista_bloque instruccion_bloque
    ;

instruccion_bloque:
    declaracion_variable
    | asignacion
    | llamada_funcion
    | retorno
    ;

parametros:
    /* vacío */ { $$ = 0; }
    | lista_param { $$ = $1; }
    ;

lista_param:
    ID { 
        agregar_variable($1); 
        $$ = 1; 
    }
    | lista_param COMA ID { 
        agregar_variable($3); 
        $$ = $1 + 1; 
    }
    ;

asignacion:
    ID IGUAL ID PUNTOYCOMA {
        if (!buscar_variable($1) || !buscar_variable($3)) {
            printf("Error: identificador no declarado\n");
        }
    }
    ;

llamada_funcion:
    ID PARIZQ argumentos PARDER PUNTOYCOMA {
        int esperados = buscar_funcion($1);
        if (esperados != $3) {
            printf("Error: función '%s' espera 2 argumentos\n", $1);
        }
    }
    ;

retorno:
    RETURN ID PUNTOYCOMA {
        if (!buscar_variable($2)) {
            printf("Error: identificador no declarado\n");
        }
    }
    ;

argumentos:
    /* vacío */ { $$ = 0; }
    | lista_args { $$ = $1; }
    ;

lista_args:
    ID {
        if (!buscar_variable($1)) {
            printf("Error: identificador no declarado\n");
        }
        $$ = 1;
    }
    | lista_args COMA ID {
        if (!buscar_variable($3)) {
            printf("Error: identificador no declarado\n");
        }
        $$ = $1 + 1;
    }
    ;

%%

int main() {
    return yyparse();
}