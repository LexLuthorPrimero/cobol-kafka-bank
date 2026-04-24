import unittest, json, tempfile, shutil, os, sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
import bridge.bridge as bridge_module

class TestBridge(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.temp_dir = tempfile.mkdtemp()
        cls.accounts_file = Path(cls.temp_dir) / "ACCOUNTS.DAT"
        cls.input_file = Path(cls.temp_dir) / "trans_input.txt"
        cls.inbox = Path(cls.temp_dir) / "inbox"
        cls.processed = Path(cls.temp_dir) / "processed"
        os.environ['ACCOUNTS_FILE'] = str(cls.accounts_file)
        os.environ['BRIDGE_INPUT_FILE'] = str(cls.input_file)
        os.environ['BRIDGE_INBOX'] = str(cls.inbox)
        os.environ['BRIDGE_PROCESSED'] = str(cls.processed)
        for d in [cls.inbox, cls.processed]:
            d.mkdir(exist_ok=True)
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
        self.assertIn("001450000", self.accounts_file.read_text())
    def test_actualizar_saldo_insuficiente(self):
        bridge_module.actualizar_saldo("00001", 2000000)
        self.assertIn("-00500000", self.accounts_file.read_text())
    def test_procesar_archivo_autorizado(self):
        archivo = self.inbox / "tx-test.json"
        archivo.write_text('{"id": 2, "monto": 300}')
        bridge_module.procesar_archivo(archivo)
        self.assertIn("001970000", self.accounts_file.read_text())
