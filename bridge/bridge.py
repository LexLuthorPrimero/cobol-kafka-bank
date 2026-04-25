import os, json, subprocess, time, shutil
from pathlib import Path

def _get_path(env_var, default):
    return Path(os.environ.get(env_var, default))

def run_cobol(program):
    env = os.environ.copy()
    env["ACCOUNTS_PATH"] = os.environ.get("ACCOUNTS_PATH", "/app/accounts/ACCOUNTS.DAT")

    cobol_dir = _get_path('COBOL_DIR', '/app')
    env = os.environ.copy()
    # Pasar la ruta del archivo de cuentas al COBOL (si está configurada)
    if 'ACCOUNTS_PATH' in env:
        env['ACCOUNTS_PATH'] = env['ACCOUNTS_PATH']
    else:
        env['ACCOUNTS_PATH'] = '/app/accounts/ACCOUNTS.DAT'
    result = subprocess.run(
        [str(cobol_dir / program)],
        capture_output=True, text=True, cwd=str(cobol_dir), env=env
    )
    if result.returncode != 0:
        raise Exception(f"COBOL program '{program}' failed with returncode {result.returncode}: {result.stderr.strip()}")
    return result.stdout.strip()

def actualizar_saldo(tid, monto):
    """monto viene en centavos (ej. 50000 para $500.00). No se multiplica."""
    accounts = _get_path('ACCOUNTS_FILE', '/app/accounts/ACCOUNTS.DAT')
    try:
        with open(accounts, 'r') as f:
            lineas = f.readlines()
    except FileNotFoundError:
        print(f"[BRIDGE] ERROR: {accounts} no encontrado")
        return

    nuevas = []
    for linea in lineas:
        linea = linea.rstrip('\r\n')
        if linea[:5] == tid:
            saldo_actual = int(linea[25:34]) if len(linea) >= 34 else 0
            nuevo_saldo = saldo_actual - monto
            linea = f"{tid}{linea[5:25].ljust(20)}{nuevo_saldo:09d}"
            print(f"[BRIDGE] Saldo actualizado: {saldo_actual} -> {nuevo_saldo}")
        nuevas.append(linea + '\n')

    with open(accounts, 'w') as f:
        f.writelines(nuevas)

def procesar_archivo(path: Path):
    try:
        tx = json.loads(path.read_text())
        tid = str(tx.get('id', '')).zfill(5)
        monto_str = str(tx.get('monto', '0'))
        if '.' in monto_str:
            dollars, cents = monto_str.split('.')
            cents = cents.ljust(2, '0')[:2]  # asegurar 2 dígitos
        else:
            dollars = monto_str
            cents = '00'
        amt = int(dollars) * 100 + int(cents)
        if not tid or not amt:
            print(f"[BRIDGE] Datos incompletos en {path.name}")
            return
        input_file = _get_path('BRIDGE_INPUT_FILE', '/app/trans_input.txt')
        input_file.parent.mkdir(parents=True, exist_ok=True)
        with open(input_file, 'w') as f:
            f.write(f'{tid} {amt:09d}\n')
        print(f"[BRIDGE] Procesando {path.name}: ID={tid} Monto={amt}")
        res = run_cobol('procesa_transaccion')
        print(f'Resultado procesa_transaccion: {res}')
        if res not in ['OK', 'ERROR']:
            raise Exception(f"Invalid response from COBOL: '{res}'")
        if res == 'OK':
            print(f'Transaccion completada para ID {tid}')
            processed = _get_path('BRIDGE_PROCESSED', '/app/processed')
            processed.mkdir(parents=True, exist_ok=True)
            shutil.move(str(path), str(processed / path.name))
        else:
            print(f'Transaccion RECHAZADA para ID {tid}')
    except Exception as e:
        print(f"[BRIDGE] Error procesando {path.name}: {e}")
        import traceback
        traceback.print_exc()

def main_loop():
    inbox = _get_path('BRIDGE_INBOX', '/app/inbox')
    processed = _get_path('BRIDGE_PROCESSED', '/app/processed')
    inbox.mkdir(parents=True, exist_ok=True)
    processed.mkdir(parents=True, exist_ok=True)
    print(f"[BRIDGE] Buscando transacciones en {inbox} ...")
    while True:
        for archivo in sorted(inbox.glob("tx-*.json")):
            procesar_archivo(archivo)
        time.sleep(1)

if __name__ == "__main__":
    main_loop()
