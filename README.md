# Sistema Bancario Simulado - COBOL + Python + Kafka

[![COBOL CI](https://github.com/LexLuthorPrimero/cobol-kafka-bank/actions/workflows/ci.yml/badge.svg)](https://github.com/LexLuthorPrimero/cobol-kafka-bank/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![COBOL](https://img.shields.io/badge/COBOL-100%25-blue)]()

Proyecto demostrativo de un sistema bancario transaccional con procesamiento batch y online, integrando COBOL ANSI-85, Python y Apache Kafka.

## Arquitectura (Modo Archivos)
```mermaid
flowchart LR
    A[Productor] -->|Deposita JSON| B[inbox/]
    B -->|Bridge.py| C{COBOL}
    C -->|Autorización| D[actualizar_saldo]
    D --> E[accounts/ACCOUNTS.DAT]
    B -->|Mueve a| F[processed/]
```

## Tecnologías
- **COBOL ANSI-85** (GnuCOBOL)
- **Python** (bridge, productor)
- **Apache Kafka** (opcional)
- **Docker** (contenedores)
- **CI/CD** (GitHub Actions)

## Ejecución Rápida (Modo Archivos)
```bash
git clone https://github.com/LexLuthorPrimero/cobol-kafka-bank.git
cd cobol-kafka-bank
docker compose up -d
echo '{"id": 1, "monto": 500}' > inbox/tx-test.json
cat accounts/ACCOUNTS.DAT  # Saldo actualizado
```

## Palabras Clave ATS
`COBOL` `Mainframe` `Batch Processing` `CICS` `DB2` `VSAM` `Python` `Docker` `Kafka` `CI/CD` `Legacy Modernization`
