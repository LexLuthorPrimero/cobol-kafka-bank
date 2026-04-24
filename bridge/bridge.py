import os, json, subprocess, time, shutil
from pathlib import Path

INBOX     = Path("/app/inbox")
PROCESSED = Path("/app/processed")
COBOL_DIR = "/app"
INPUT_FILE = "/app/trans_input.txt"
ACCOUNTS_FILE = os.environ.get('ACCOUNTS_FILE', '/app/accounts/ACCOUNTS.DAT')

def run_cobol(program):
    return subprocess.run([f'{COBOL_DIR}/{program}'], capture_output=True, text=True).stdout.strip()

def actualizar_saldo(tid, monto):
    try:
        with open(ACCOUNTS_FILE, 'r') as f:
            lineas = f.readlines()
    except FileNotFoundError:
        print(f"[BRIDGE] ERROR: {ACCOUNTS_FILE} no encontrado")
        return

    nuevas = []
    for linea in lineas:
        linea = linea.rstrip('\r\n')
        # Extraer ID (primeros 5 caracteres)
        id_cuenta = linea[:5]
        if id_cuenta == tid:
            # Extraer nombre (caracteres 5-24, dejamos intacto)
            nombre = linea[5:25].rstrip()
            saldo_actual = int(linea[25:34]) if len(linea) >= 34 else 0
            nuevo_saldo = saldo_actual - monto
            # Reconstruir línea con formato exacto: 5 ID + 20 nombre + 7 saldo
            nombre_just = nombre.ljust(20)[:20]
            linea = f"{tid}{nombre_just}{nuevo_saldo:09d}"
            print(f"[BRIDGE] Saldo actualizado: {saldo_actual} -> {nuevo_saldo}")
        nuevas.append(linea + '\n')

    with open(ACCOUNTS_FILE, 'w') as f:
        f.writelines(nuevas)

def procesar_archivo(path: Path):
    try:
        tx = json.loads(path.read_text())
        tid = str(tx.get('id', '')).zfill(5)
        amt = int(float(tx.get('monto', 0)) * 100)
        if not tid or not amt:
            print(f"[BRIDGE] Datos incompletos en {path.name}")
            return

        with open(INPUT_FILE, 'w') as f:
            f.write(f'{tid} {amt:09d}\n')

        print(f"[BRIDGE] Procesando {path.name}: ID={tid} Monto={amt}")
        res = run_cobol('autorizador')
        print(f'Resultado autorizador: {res}')

        if res == 'AUTORIZADO':
            actualizar_saldo(tid, amt)
            run_cobol('actualizador_saldo')
            print(f'Transaccion completada para ID {tid}')
        else:
            print(f'Transaccion RECHAZADA para ID {tid}')

    except Exception as e:
        print(f"[BRIDGE] Error procesando {path.name}: {e}")
        import traceback
        traceback.print_exc()
    else:
        # Solo mover si no hubo excepción
        shutil.move(str(path), str(PROCESSED / path.name))

INBOX.mkdir(exist_ok=True)
PROCESSED.mkdir(exist_ok=True)
print(f"[BRIDGE] Buscando transacciones en {INBOX} ...")

while True:
    archivos = sorted(INBOX.glob("tx-*.json"))
    for archivo in archivos:
        procesar_archivo(archivo)
    time.sleep(1)
