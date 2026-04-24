from kafka import KafkaProducer, KafkaConsumer
import json, time

BROKER = 'kafka:9092'
TOPIC = 'transacciones'

# Producir un mensaje de prueba
try:
    producer = KafkaProducer(bootstrap_servers=BROKER,
                             value_serializer=lambda v: json.dumps(v).encode('utf-8'))
    producer.send(TOPIC, {'id': 1, 'monto': 500})
    producer.flush()
    print("Mensaje enviado correctamente")
except Exception as e:
    print(f"Error produciendo: {e}")

# Pequeña pausa
time.sleep(1)

# Consumir un mensaje
try:
    consumer = KafkaConsumer(TOPIC,
                             bootstrap_servers=BROKER,
                             auto_offset_reset='earliest',
                             group_id='test-group-final',
                             value_deserializer=lambda x: x.decode('utf-8'))
    print("Esperando mensaje...")
    for msg in consumer:
        print(f"Recibido: {msg.value}")
        break
    consumer.close()
except Exception as e:
    print(f"Error consumiendo: {e}")
