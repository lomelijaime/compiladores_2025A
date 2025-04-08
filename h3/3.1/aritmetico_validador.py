import ply.lex as lex
import ply.yacc as yacc
import sys

# --- Analizador Léxico (Lexer) ---

tokens = (
    'NUMBER',
    'PLUS', 'MINUS', 'TIMES', 'DIVIDE',
    'LPAREN', 'RPAREN',
)

# Ignorar espacios y tabs
t_ignore = ' \t'

# Definición de tokens simples (operadores y paréntesis)
t_PLUS    = r'\+'
t_MINUS   = r'-'
t_TIMES   = r'\*'
t_DIVIDE  = r'/'
t_LPAREN  = r'\('
t_RPAREN  = r'\)'

# Definición de token NUMBER (números enteros)
def t_NUMBER(t):
    r'\d+'
    t.value = int(t.value) # Guardar el valor convertido a entero
    return t

# Manejo de saltos de línea (para contar líneas si fuera necesario)
def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

# Manejo de errores léxicos
def t_error(t):
    print(f"Caracter ilegal '{t.value[0]}' en la línea {t.lexer.lineno}")
    t.lexer.skip(1)

# Construir el lexer
lexer = lex.lex()

# --- Analizador Sintáctico (Parser) ---

# Definición de la precedencia de operadores
precedence = (
    ('left', 'PLUS', 'MINUS'),
    ('left', 'TIMES', 'DIVIDE'),
    # ('right', 'UMINUS'), # Para el menos unario si se necesitara
)

# Definición de las reglas de la gramática (basadas en la BNF)
def p_expression_plus(p):
    'expr : expr PLUS term'
    # En validación, no necesitamos calcular, solo aceptar la regla
    pass # print("Regla: expr -> expr + term")

def p_expression_minus(p):
    'expr : expr MINUS term'
    pass # print("Regla: expr -> expr - term")

def p_expression_term(p):
    'expr : term'
    pass # print("Regla: expr -> term")

def p_term_times(p):
    'term : term TIMES factor'
    pass # print("Regla: term -> term * factor")

def p_term_divide(p):
    'term : term DIVIDE factor'
    pass # print("Regla: term -> term / factor")

def p_term_factor(p):
    'term : factor'
    pass # print("Regla: term -> factor")

def p_factor_paren(p):
    'factor : LPAREN expr RPAREN'
    pass # print("Regla: factor -> ( expr )")

def p_factor_number(p):
    'factor : NUMBER'
    pass # print("Regla: factor -> NUMBER")

# Manejo de errores sintácticos
def p_error(p):
    if p:
        print(f"Error de sintaxis cerca de '{p.value}' (tipo: {p.type}) en la línea {p.lineno}")
    else:
        print("Error de sintaxis: Fin inesperado de la entrada")
    # sys.exit(1) # Opcional: terminar el programa en error

# Construir el parser
parser = yacc.yacc()

# --- Función principal para validar ---
print("Validador de Expresiones Aritméticas. Escribe expresiones (o 'salir'):")
while True:
    try:
        s = input('> ')
    except EOFError:
        break
    if not s or s.lower() == 'salir':
        break
    if s.strip(): # Solo procesar si no está vacío
        try:
            result = parser.parse(s, lexer=lexer)
            # Si parse() no lanza excepción y p_error no se llamó (o no salió), es válida
            
        except Exception as e:
            # Captura otras excepciones inesperadas durante el parseo
            print(f"Error inesperado durante el análisis: {e}")