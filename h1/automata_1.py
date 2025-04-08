def validate_alpha(s):
    return s.isalpha()

input_str = input("Ingrese una cadena: ")

if validate_alpha(input_str):
    print("Cadena válida.")
else:
    print("Cadena inválida.")