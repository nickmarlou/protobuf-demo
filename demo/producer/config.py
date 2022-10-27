KAFKA_BOOTSTRAP_SERVERS = "host.docker.internal:9092"
SCHEMA_REGISTRY_URL = "http://host.docker.internal:8081"

PRODUCER_CONFIG = {
    "bootstrap.servers": KAFKA_BOOTSTRAP_SERVERS,
}
