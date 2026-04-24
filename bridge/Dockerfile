FROM python:3.12-slim

RUN apt-get update && apt-get install -y --no-install-recommends gnucobol && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY cobol/ /app/cobol/
RUN echo "=== Archivos COBOL en imagen ===" && ls -la /app/cobol/ && test -f /app/cobol/autorizador.cob || (echo "ERROR: autorizador.cob no encontrado" && exit 1)

RUN cobc -x -o /app/autorizador /app/cobol/autorizador.cob && \
    cobc -x -o /app/procesador_pago /app/cobol/procesador_pago.cob && \
    cobc -x -o /app/actualizador_saldo /app/cobol/actualizador_saldo.cob && \
    echo "=== Binarios compilados ===" && ls -la /app/autorizador /app/procesador_pago /app/actualizador_saldo

RUN pip install --no-cache-dir kafka-python

COPY bridge/bridge.py /app/bridge.py

RUN mkdir -p /app/accounts /app/logs

CMD ["python", "/app/bridge.py"]
