import json
import subprocess
import time
from pathlib import Path

INBOX = Path("../inbox")
PROCESSED = Path("../processed")
ACCOUNTS_FILE = Path("../accounts/ACCOUNTS.DAT")

def test_transaccion_autorizada():
    # Preparar archivo de cuentas limpio
    ACCOUNTS_FILE.write_text("00001Juan Perez          001500000\n" +
                             "00002Maria Gomez         002000000\n" +
                             "00003Carlos Lopez        000800000\n")
    # Limpiar bandejas
    for f in INBOX.glob("*.json"): f.unlink()
    for f in PROCESSED.glob("*"): f.unlink()

    # Depositar transacción
    tx = {"id": 1, "monto": 500}
    (INBOX / "tx-test.json").write_text(json.dumps(tx))

    # Esperar que el bridge la procese (máximo 10 segundos)
    for _ in range(10):
        if (PROCESSED / "tx-test.json").exists():
            break
        time.sleep(1)

    # Verificar saldo actualizado
    contenido = ACCOUNTS_FILE.read_text()
    assert "001450000" in contenido, f"El saldo no se actualizó. Contenido: {contenido}"
cat > .github/workflows/ci.yml << 'EOF'
name: COBOL Bridge CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Instalar GnuCOBOL y Python
        run: |
          sudo apt-get update
          sudo apt-get install -y gnucobol python3 python3-pip
      - name: Compilar COBOL
        run: |
          cd cobol
          cobc -x -o autorizador autorizador.cob
          cobc -x -o procesador_pago procesador_pago.cob
          cobc -x -o actualizador_saldo actualizador_saldo.cob
      - name: Ejecutar tests COBOL
        run: ./test.sh
      - name: Ejecutar tests Python
        run: |
          cd tests
          python3 -m unittest test_bridge.py
