KAFKA_BOOTSTRAP_SERVERS = "host.docker.internal:9092"

CONSUMER_CONFIG = {
    "bootstrap.servers": KAFKA_BOOTSTRAP_SERVERS,
    "group.id": "protobuf-demo",
    "auto.offset.reset": "earliest",
}
