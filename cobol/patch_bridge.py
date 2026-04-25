import os
import shutil
import subprocess

ACCOUNTS_PATH = os.getenv("ACCOUNTS_PATH", "accounts/ACCOUNTS.DAT")

def run_cobol():
    result = subprocess.run(
        ["./procesa_transaccion.sh"],
        capture_output=True,
        text=True
    )

    print(result.stdout)

    if result.returncode != 0:
        print("ERROR COBOL:")
        print(result.stderr)
        return False

    output = result.stdout.strip().upper()

    if not output.startswith("OK"):
        print("TRANSACCION RECHAZADA O SIN OK")
        return False

    tmp_file = ACCOUNTS_PATH + ".tmp"

    if not os.path.exists(tmp_file):
        print("ERROR: ARCHIVO TEMPORAL INEXISTENTE")
        return False

    backup = ACCOUNTS_PATH + ".bak"

    if os.path.exists(ACCOUNTS_PATH):
        shutil.copy(ACCOUNTS_PATH, backup)

    shutil.move(tmp_file, ACCOUNTS_PATH)

    print("COMMIT APLICADO CORRECTAMENTE")
    return True

if __name__ == "__main__":
    run_cobol()
