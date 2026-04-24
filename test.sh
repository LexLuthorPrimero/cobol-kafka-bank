#!/bin/bash
set -e
echo "🧪 Suite de pruebas COBOL"

# Crear directorios como en el contenedor
mkdir -p /tmp/test_cobol/app/accounts
cd /tmp/test_cobol/app

# Copiar archivos de cuentas (ruta esperada por COBOL: '/app/accounts/ACCOUNTS.DAT')
cp ~/cobol-kafka-bank/accounts/ACCOUNTS.DAT accounts/ACCOUNTS.DAT

# Compilar los programas fuente (sin depender de rutas absolutas)
cp ~/cobol-kafka-bank/cobol/*.cob .
rm -f autorizador procesador_pago actualizador_saldo

echo ">> Compilando..."
cobc -x -o autorizador autorizador.cob
cobc -x -o procesador_pago procesador_pago.cob
cobc -x -o actualizador_saldo actualizador_saldo.cob
echo "✅ Compilación OK"

# Prueba 1: autorización válida (ID 1, monto 500.00)
echo ">> Prueba 1: autorización válida"
printf "00001 000050000\n" > /app/trans_input.txt
./autorizador
if ./autorizador | grep -q "AUTORIZADO"; then
    echo "✅ Prueba 1 OK"
else
    echo "ERROR: Prueba 1 fallida"
    exit 1
fi

# Prueba 2: fondos insuficientes (ID 1, monto 20000.00)
echo ">> Prueba 2: fondos insuficientes"
printf "00001 020000000\n" > /app/trans_input.txt
if ./autorizador | grep -q "RECHAZADO"; then
    echo "✅ Prueba 2 OK"
else
    echo "ERROR: Prueba 2 fallida"
    exit 1
fi

# Prueba 3: cuenta inexistente
echo ">> Prueba 3: cuenta inexistente"
printf "99999 000050000\n" > /app/trans_input.txt
if ./autorizador | grep -q "RECHAZADO"; then
    echo "✅ Prueba 3 OK"
else
    echo "ERROR: Prueba 3 fallida"
    exit 1
fi

echo "✅ Todas las pruebas COBOL pasaron"
