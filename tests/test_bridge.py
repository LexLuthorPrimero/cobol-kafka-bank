import os; os.environ.setdefault('COBOL_DIR', '/app')
import unittest
import json
import tempfile
import shutil
import os
import sys
from pathlib import Path

# Configurar entorno ANTES de importar el módulo bridge
TEST_DIR = tempfile.mkdtemp()
os.environ['BRIDGE_INBOX'] = str(Path(TEST_DIR) / 'inbox')
os.environ['BRIDGE_PROCESSED'] = str(Path(TEST_DIR) / 'processed')
os.environ['BRIDGE_INPUT_FILE'] = str(Path(TEST_DIR) / 'trans_input.txt')
os.environ['ACCOUNTS_FILE'] = str(Path(TEST_DIR) / 'ACCOUNTS.DAT')

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

# Ahora importamos el módulo (no ejecuta su main_loop)
import bridge.bridge as bridge_module

class TestBridge(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # Crear carpeta inbox para los tests
        Path(os.environ['BRIDGE_INBOX']).mkdir(parents=True, exist_ok=True)
        Path(os.environ['BRIDGE_PROCESSED']).mkdir(parents=True, exist_ok=True)

    def setUp(self):
        # Archivo de cuentas limpio para cada prueba
        Path(os.environ['ACCOUNTS_FILE']).write_text(
            "00001Juan Perez          001500000\n"
            "00002Maria Gomez         002000000\n"
            "00003Carlos Lopez        000800000\n"
        )

    def tearDown(self):
        # Limpiar archivos procesados
        for f in Path(os.environ['BRIDGE_INBOX']).glob('*.json'):
            f.unlink()
        for f in Path(os.environ['BRIDGE_PROCESSED']).glob('*'):
            f.unlink()

    def test_actualizar_saldo_valido(self):
        """Probar que un descuento válido se refleja en el archivo."""
        bridge_module.actualizar_saldo("00001", 50000)  # monto en centavos
        contenido = Path(os.environ['ACCOUNTS_FILE']).read_text()
        self.assertIn("001450000", contenido)

    def test_actualizar_saldo_insuficiente(self):
        """Probar que un descuento excesivo puede dejar saldo negativo (según la lógica)."""
        bridge_module.actualizar_saldo("00001", 2000000)  # mayor que 1500000
        contenido = Path(os.environ['ACCOUNTS_FILE']).read_text()
        self.assertIn("-00500000", contenido)

    def test_procesar_archivo_autorizado(self):
        """Simular el procesamiento completo de un archivo JSON."""
        inbox = Path(os.environ['BRIDGE_INBOX'])
        tx = {"id": 2, "monto": 300}
        (inbox / "tx-test.json").write_text(json.dumps(tx))
        bridge_module.procesar_archivo(inbox / "tx-test.json")
        contenido = Path(os.environ['ACCOUNTS_FILE']).read_text()
        self.assertIn("001970000", contenido)

if __name__ == "__main__":
    unittest.main()
