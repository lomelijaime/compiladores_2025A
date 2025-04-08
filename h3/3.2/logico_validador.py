import ply.lex as lex
import ply.yacc as yacc
import sys

# --- Analizador Léxico (Lexer) ---

tokens = (
    'BOOLEAN',
    'AND', 'OR', 'NOT',
    'LPAREN', 'RPAREN',
)

# Ignorar espacios y tabs
t_ignore = ' \t'

# Definición de tokens simples (operadores y paréntesis)
t_AND    = r'AND'
t_OR     = r'OR'
t_NOT    = r'NOT'
t_LPAREN = r'\('
t_RPAREN = r'\)'

# Definición de token booleano 0 o 1 
def t_BOOLEAN(t):
    r'[01]' # Solo 0 o 1
    t.value = int(t.value) # Guardar el valor como 0 o 1
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
    ('right', 'NOT'),
    ('left', 'AND'),
    ('left', 'OR'), 
)

# Definición de las reglas de la gramática (basadas en la BNF)
def p_expression_or(p):
    'expr : expr OR term'
    pass # print("Regla: expr OR term")

def p_expression_and(p):
    'expr : expr AND term'
    pass

def p_term_not(p):
    'term : NOT factor'
    pass

def p_expression_term(p):
    'expr : term'
    pass

def p_term_factor(p):
    'term : factor'
    pass

def p_factor_paren(p):
    'factor : LPAREN expr RPAREN'
    pass

def p_factor_boolean(p):
    'factor : BOOLEAN'
    pass

# Manejo de errores sintácticos
def p_error(p):
    global parse_error_detected
    parse_error_detected = True
    if p:
        print(f"Error de sintaxis cerca de '{p.value}' (tipo: {p.type}) en la línea {p.lineno}")
    else:
        print("Error de sintaxis: Fin inesperado de la entrada")
    # sys.exit(1) # Opcional: terminar el programa en error

# Construir el parser
parser = yacc.yacc()

# --- Función principal para validar ---
print("Validador de Expresiones Lógicas. Escribe expresiones (o 'salir'):")
while True:
    global parse_error_detected
    parse_error_detected = False
    try:
        s = input('> ')
    except EOFError:
        break
    if not s or s.lower() == 'salir':
        break
    if s.strip(): # Solo procesar si no está vacío
        try:
            result = parser.parse(s, lexer=lexer)
            if not parse_error_detected:
                print("Expresión válida")
            else:
                print("Expresión inválida")
        except Exception as e:
            # Captura otras excepciones inesperadas durante el parseo
            print(f"Error inesperado durante el análisis: {e}")