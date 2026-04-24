import unittest
import json
import tempfile
import shutil
from pathlib import Path
import sys
import os

# Añadir el directorio raíz al path para importar bridge
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from bridge import bridge as bridge_module

class TestBridge(unittest.TestCase):
    def setUp(self):
        # Crear archivos de cuentas temporales para cada prueba
        self.temp_dir = tempfile.mkdtemp()
        self.accounts_file = Path(self.temp_dir) / "ACCOUNTS.DAT"
        self.accounts_file.write_text(
            "00001Juan Perez          001500000\n"
            "00002Maria Gomez         002000000\n"
            "00003Carlos Lopez        000800000\n"
        )
        # Redirigir la variable de entorno para que el módulo use este archivo
        self.old_env = os.environ.get('ACCOUNTS_FILE')
        os.environ['ACCOUNTS_FILE'] = str(self.accounts_file)

    def tearDown(self):
        shutil.rmtree(self.temp_dir)
        if self.old_env is not None:
            os.environ['ACCOUNTS_FILE'] = self.old_env

    def test_actualizar_saldo_valido(self):
        """Probar que un descuento válido se refleja en el archivo."""
        bridge_module.actualizar_saldo("00001", 50000)  # monto en centavos
        contenido = self.accounts_file.read_text()
        self.assertIn("001450000", contenido)

    def test_actualizar_saldo_insuficiente(self):
        """Probar que un descuento excesivo puede dejar saldo negativo (según la lógica)."""
        bridge_module.actualizar_saldo("00001", 2000000)  # mayor que 1500000
        contenido = self.accounts_file.read_text()
        self.assertIn("-00500000", contenido)  # saldo negativo

if __name__ == "__main__":
    unittest.main()
