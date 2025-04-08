import ply.lex as lex
import sys

# Diccionario para contar tokens
contadores = {
    'palabras_clave': 0,
    'identificadores': 0,
    'numeros': 0,
    'operadores': 0,
    'delimitadores': 0,
    'cadenas': 0,
    'comentarios': 0
}

# Lista de palabras clave
palabras_clave = {
    'int', 'float', 'char', 'double', 'if', 'else', 'while',
    'for', 'return', 'void', 'struct', 'switch', 'case', 'break'
}

# Lista de tokens
tokens = [
    'IDENTIFICADOR', 'NUMERO', 'OPERADOR', 'DELIMITADOR',
    'CADENA', 'COMENTARIO', 'PALABRA_CLAVE'
]

# Reglas para tokens simples
t_OPERADOR = r'[\+\-\*\/\=\<\>\!\&\|\^\%]'
t_DELIMITADOR = r'[\(\)\{\}\[\]\;\,\.]'

# Función para identificadores
def t_IDENTIFICADOR(t):
    r'[a-zA-Z_][a-zA-Z0-9_]*'
    if t.value in palabras_clave:
        t.type = 'PALABRA_CLAVE'
        contadores['palabras_clave'] += 1
    else:
        contadores['identificadores'] += 1
    return t

# Función para números
def t_NUMERO(t):
    r'\d+(\.\d+)?([eE][+-]?\d+)?'
    contadores['numeros'] += 1
    return t

# Función para cadenas
def t_CADENA(t):
    r'"([^"\\]|\\.)*"'
    contadores['cadenas'] += 1
    return t

# Función para comentarios de una línea
def t_COMENTARIO_LINEA(t):
    r'\/\/.*'
    t.type = 'COMENTARIO'
    contadores['comentarios'] += 1
    return t

# Función para comentarios de múltiples líneas
def t_COMENTARIO_BLOQUE(t):
    r'\/\*[\s\S]*?\*\/'
    t.type = 'COMENTARIO'
    contadores['comentarios'] += 1
    # Contar saltos de línea en el comentario
    t.lexer.lineno += t.value.count('\n')
    return t

# Regla para ignorar espacios y tabulaciones
t_ignore = ' \t'

# Función para saltos de línea
def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

# Función para manejar errores
def t_error(t):
    print(f"Carácter ilegal '{t.value[0]}' en la línea {t.lexer.lineno}")
    t.lexer.skip(1)

# Construir el lexer
lexer = lex.lex()

# Función principal
def main():
    if len(sys.argv) != 2:
        print("Uso: python lexer3.py archivo.c")
        return

    try:
        with open(sys.argv[1], 'r') as file:
            data = file.read()
            
        # Proporcionar los datos al lexer
        lexer.input(data)

        # Tokenizar el input
        for tok in lexer:
            if tok.type == 'OPERADOR':
                contadores['operadores'] += 1
            elif tok.type == 'DELIMITADOR':
                contadores['delimitadores'] += 1

        # Imprimir resultados
        print("\nAnálisis léxico completado.")
        print(f"Palabras clave: {contadores['palabras_clave']}")
        print(f"Identificadores: {contadores['identificadores']}")
        print(f"Números: {contadores['numeros']}")
        print(f"Operadores: {contadores['operadores']}")
        print(f"Delimitadores: {contadores['delimitadores']}")
        print(f"Cadenas: {contadores['cadenas']}")
        print(f"Comentarios: {contadores['comentarios']}")
        
    except FileNotFoundError:
        print(f"Error: El archivo {sys.argv[1]} no existe")

if __name__ == "__main__":
    main()