def procesar_archivo(path):
    import subprocess

    res = subprocess.check_output(["cobc-run", path]).decode().strip()

    if res not in ["OK", "ERROR"]:
        raise Exception(f"Respuesta no válida de COBOL: '{res}'")

    return res
