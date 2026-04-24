import unittest, json, tempfile, shutil, os, sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
import bridge.bridge as bridge_module

class TestBridge(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # Usar directorios dentro del workspace del CI (permisos garantizados)
        cls.workspace = Path(os.environ.get('GITHUB_WORKSPACE', '/home/runner/work/cobol-kafka-bank/cobol-kafka-bank'))
        cls.accounts_file = cls.workspace / 'accounts' / 'ACCOUNTS.DAT'
        cls.input_file = cls.workspace / 'trans_input.txt'
        cls.inbox = cls.workspace / 'inbox_test'
        cls.processed = cls.workspace / 'processed_test'
        for d in [cls.inbox, cls.processed]:
            d.mkdir(exist_ok=True)
        # Asegurar que las rutas COBOL apunten a estos paths
        os.environ['ACCOUNTS_FILE'] = str(cls.accounts_file)
        os.environ['BRIDGE_INPUT_FILE'] = str(cls.input_file)
        os.environ['BRIDGE_INBOX'] = str(cls.inbox)
        os.environ['BRIDGE_PROCESSED'] = str(cls.processed)

    def setUp(self):
        self.accounts_file.write_text(
            "00001Juan Perez          001500000\n"
            "00002Maria Gomez         002000000\n"
            "00003Carlos Lopez        000800000\n"
        )

    def tearDown(self):
        for d in [self.inbox, self.processed]:
            for f in d.glob('*'): f.unlink()

    def test_actualizar_saldo_valido(self):
        bridge_module.actualizar_saldo("00001", 50000)
        self.assertIn("001450000", self.accounts_file.read_text())

    def test_actualizar_saldo_insuficiente(self):
        bridge_module.actualizar_saldo("00001", 2000000)
        self.assertIn("-00500000", self.accounts_file.read_text())

    def test_procesar_archivo_autorizado(self):
        tx = {"id": 2, "monto": 300}
        (self.inbox / "tx-test.json").write_text(json.dumps(tx))
        bridge_module.procesar_archivo(self.inbox / "tx-test.json")
        self.assertIn("001970000", self.accounts_file.read_text())
