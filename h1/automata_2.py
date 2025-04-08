def validate_real(s):
    try:
        float(s)
        return True
    except ValueError:
        return False


input_str = input("Ingrese un número real: ")
if validate_real(input_str):
    print("Número válido.")
else:
    print("Número inválido.")