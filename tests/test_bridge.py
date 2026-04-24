import unittest, json, tempfile, shutil, os, sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
import bridge.bridge as bridge_module

class TestBridge(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # Crear directorio temporal único para todas las pruebas
        cls.temp_dir = tempfile.mkdtemp()
        cls.accounts_file = Path(cls.temp_dir) / "ACCOUNTS.DAT"
        cls.input_file = Path(cls.temp_dir) / "trans_input.txt"
        cls.inbox = Path(cls.temp_dir) / "inbox"
        cls.processed = Path(cls.temp_dir) / "processed"
        for d in [cls.inbox, cls.processed]:
            d.mkdir(exist_ok=True)

        # Configurar las variables de entorno que bridge.py lee
        os.environ['ACCOUNTS_FILE'] = str(cls.accounts_file)
        os.environ['BRIDGE_INPUT_FILE'] = str(cls.input_file)
        os.environ['BRIDGE_INBOX'] = str(cls.inbox)
        os.environ['BRIDGE_PROCESSED'] = str(cls.processed)

    @classmethod
    def tearDownClass(cls):
        shutil.rmtree(cls.temp_dir)

    def setUp(self):
        self.accounts_file.write_text(
            "00001Juan Perez          001500000\n"
            "00002Maria Gomez         002000000\n"
            "00003Carlos Lopez        000800000\n"
        )

    def test_actualizar_saldo_valido(self):
        bridge_module.actualizar_saldo("00001", 50000)
        contenido = self.accounts_file.read_text()
        self.assertIn("001450000", contenido)

    def test_actualizar_saldo_insuficiente(self):
        bridge_module.actualizar_saldo("00001", 2000000)
        contenido = self.accounts_file.read_text()
        self.assertIn("-00500000", contenido)

    def test_procesar_archivo_autorizado(self):
        """Procesa un JSON de prueba y verifica que el saldo se actualiza."""
        tx = {"id": 2, "monto": 300}
        archivo = self.inbox / "tx-test.json"
        archivo.write_text(json.dumps(tx))
        bridge_module.procesar_archivo(archivo)
        contenido = self.accounts_file.read_text()
        self.assertIn("001970000", contenido)

if __name__ == "__main__":
    unittest.main()
