#!/bin/bash
echo "🧪 Suite de pruebas COBOL"
rm -f autorizador procesador_pago actualizador_saldo
echo ">> Compilando..."
cobc -x -o autorizador cobol/autorizador.cob || exit 1
cobc -x -o procesador_pago cobol/procesador_pago.cob || exit 1
cobc -x -o actualizador_saldo cobol/actualizador_saldo.cob || exit 1
echo "✅ Compilación OK"
echo ">> Prueba 1: autorización válida"
printf "00001 000050000\n" > trans_input.txt
./autorizador | grep -q "AUTORIZADO" || { echo "ERROR: Prueba 1 fallida"; exit 1; }
echo "✅ Prueba 1 OK"
echo ">> Prueba 2: fondos insuficientes"
printf "00001 020000000\n" > trans_input.txt
./autorizador | grep -q "RECHAZADO" || { echo "ERROR: Prueba 2 fallida"; exit 1; }
echo "✅ Prueba 2 OK"
echo ">> Prueba 3: cuenta inexistente"
printf "99999 000050000\n" > trans_input.txt
./autorizador | grep -q "RECHAZADO" || { echo "ERROR: Prueba 3 fallida"; exit 1; }
echo "✅ Prueba 3 OK"
echo "✅ Todas las pruebas COBOL pasaron"
