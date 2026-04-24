#!/bin/bash
set -e
echo "🧪 Suite de pruebas COBOL (entorno CI amigable)"

# 1. Crear directorio de trabajo temporal
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# 2. Copiar archivos fuente del repositorio (raíz actual)
cp "$GITHUB_WORKSPACE/cobol/"*.cob . 2>/dev/null || cp ./cobol/*.cob .

# 3. Ajustar las rutas absolutas a rutas relativas para pruebas
sed -i "s|ASSIGN TO '/app/accounts/ACCOUNTS\.DAT'|ASSIGN TO 'ACCOUNTS.DAT'|g" *.cob
sed -i "s|ASSIGN TO '/app/trans_input\.txt'|ASSIGN TO 'trans_input.txt'|g" *.cob

# 4. Crear archivo de cuentas de prueba
printf "00001Juan Perez          001500000\n00002Maria Gomez         002000000\n00003Carlos Lopez        000800000\n" > ACCOUNTS.DAT

# 5. Compilar los programas
echo ">> Compilando..."
cobc -x -o autorizador autorizador.cob
cobc -x -o procesador_pago procesador_pago.cob
cobc -x -o actualizador_saldo actualizador_saldo.cob
echo "✅ Compilación OK"

# 6. Pruebas
echo ">> Prueba 1: autorización válida"
printf "00001 000050000\n" > trans_input.txt
if ./autorizador | grep -q "AUTORIZADO"; then
    echo "✅ Prueba 1 OK"
else
    echo "ERROR: Prueba 1 fallida"
    exit 1
fi

echo ">> Prueba 2: fondos insuficientes"
printf "00001 020000000\n" > trans_input.txt
if ./autorizador | grep -q "RECHAZADO"; then
    echo "✅ Prueba 2 OK"
else
    echo "ERROR: Prueba 2 fallida"
    exit 1
fi

echo ">> Prueba 3: cuenta inexistente"
printf "99999 000050000\n" > trans_input.txt
if ./autorizador | grep -q "RECHAZADO"; then
    echo "✅ Prueba 3 OK"
else
    echo "ERROR: Prueba 3 fallida"
    exit 1
fi

echo "✅ Todas las pruebas COBOL pasaron"
cd ~
rm -rf "$TEST_DIR"
