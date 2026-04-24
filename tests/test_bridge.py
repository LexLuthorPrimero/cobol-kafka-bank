import unittest
import json
import tempfile
import shutil
import os
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

import bridge.bridge as bridge_module

class TestBridge(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # Usar las rutas del entorno Docker simulado
        cls.accounts_file = Path(os.environ.get('ACCOUNTS_FILE', '/app/accounts/ACCOUNTS.DAT'))
        cls.input_file = Path(os.environ.get('BRIDGE_INPUT_FILE', '/app/trans_input.txt'))
        cls.inbox = Path(os.environ.get('BRIDGE_INBOX', '/app/inbox'))
        cls.processed = Path(os.environ.get('BRIDGE_PROCESSED', '/app/processed'))
        cls.inbox.mkdir(parents=True, exist_ok=True)
        cls.processed.mkdir(parents=True, exist_ok=True)

    def setUp(self):
        # Restaurar el archivo de cuentas original antes de cada prueba
        self.accounts_file.write_text(
            "00001Juan Perez          001500000\n"
            "00002Maria Gomez         002000000\n"
            "00003Carlos Lopez        000800000\n"
        )

    def tearDown(self):
        # Limpiar inbox/processed
        for f in self.inbox.glob('*.json'):
            f.unlink()
        for f in self.processed.glob('*'):
            f.unlink()

    def test_actualizar_saldo_valido(self):
        """Probar que un descuento válido se refleja en el archivo."""
        bridge_module.actualizar_saldo("00001", 50000)
        contenido = self.accounts_file.read_text()
        self.assertIn("001450000", contenido)

    def test_actualizar_saldo_insuficiente(self):
        """Probar que un descuento excesivo puede dejar saldo negativo (según la lógica)."""
        bridge_module.actualizar_saldo("00001", 2000000)
        contenido = self.accounts_file.read_text()
        self.assertIn("-00500000", contenido)

    def test_procesar_archivo_autorizado(self):
        """Simular el procesamiento completo de un archivo JSON."""
        tx = {"id": 2, "monto": 300}
        archivo = self.inbox / "tx-test.json"
        archivo.write_text(json.dumps(tx))

        # Llamar al procesamiento (usa las rutas del entorno)
        bridge_module.procesar_archivo(archivo)

        contenido = self.accounts_file.read_text()
        self.assertIn("001970000", contenido)

if __name__ == "__main__":
    unittest.main()
