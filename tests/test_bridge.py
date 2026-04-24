import json
import time
import subprocess
import sys
import os
from pathlib import Path

# Rutas relativas al directorio del proyecto (asumimos que se ejecuta desde la raíz)
PROJECT_DIR = Path(__file__).resolve().parent.parent
INBOX = PROJECT_DIR / "inbox"
PROCESSED = PROJECT_DIR / "processed"
ACCOUNTS_FILE = PROJECT_DIR / "accounts" / "ACCOUNTS.DAT"
BRIDGE_SCRIPT = PROJECT_DIR / "bridge" / "bridge.py"

def setup_module():
    """Prepara el entorno de prueba."""
    INBOX.mkdir(exist_ok=True)
    PROCESSED.mkdir(exist_ok=True)
    # Limpiar contenido previo
    for f in INBOX.glob("*.json"):
        f.unlink()
    for f in PROCESSED.glob("*"):
        f.unlink()
    # Archivo de cuentas de prueba
    ACCOUNTS_FILE.write_text(
        "00001Juan Perez          001500000\n"
        "00002Maria Gomez         002000000\n"
        "00003Carlos Lopez        000800000\n"
    )

def test_transaccion_autorizada():
    """Verifica que una transacción válida actualiza el saldo."""
    # Iniciar el bridge en segundo plano (si no está corriendo)
    # Para CI, simplemente procesamos directamente usando el bridge como módulo
    # O simulamos depositando el archivo y esperando.
    tx = {"id": 1, "monto": 500}
    (INBOX / "tx-test.json").write_text(json.dumps(tx))

    # En lugar de esperar al bridge, ejecutamos el proceso directamente (modo test)
    # Esto evita depender de un servicio corriendo.
    from bridge import bridge as bridge_module
    bridge_module.INBOX = INBOX
    bridge_module.PROCESSED = PROCESSED
    bridge_module.ACCOUNTS_FILE = ACCOUNTS_FILE
    bridge_module.process_archive(INBOX / "tx-test.json")

    contenido = ACCOUNTS_FILE.read_text()
    assert "001450000" in contenido, f"El saldo no se actualizó. Contenido: {contenido}"

def test_transaccion_rechazada():
    """Verifica que una transacción con fondos insuficientes no descuente."""
    ACCOUNTS_FILE.write_text(
        "00001Juan Perez          001500000\n"
        "00002Maria Gomez         002000000\n"
        "00003Carlos Lopez        000800000\n"
    )
    tx = {"id": 1, "monto": 20000}  # mayor que saldo
    (INBOX / "tx-rechazo.json").write_text(json.dumps(tx))

    from bridge import bridge as bridge_module
    bridge_module.INBOX = INBOX
    bridge_module.PROCESSED = PROCESSED
    bridge_module.ACCOUNTS_FILE = ACCOUNTS_FILE
    bridge_module.process_archive(INBOX / "tx-rechazo.json")

    contenido = ACCOUNTS_FILE.read_text()
    assert "001500000" in contenido, f"El saldo no debería haber cambiado. Contenido: {contenido}"
