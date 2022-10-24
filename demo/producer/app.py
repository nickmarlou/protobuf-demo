import uvicorn
from aio_producer import AIOProducer
from api import api_router
from config import KAFKA_BOOTSTRAP_SERVERS, SCHEMA_REGISTRY_URL
from confluent_kafka.schema_registry import SchemaRegistryClient
from fastapi import FastAPI

app = FastAPI()


def create_schema_registry_client():
    app.state.schema_registry_client = SchemaRegistryClient(
        {"url": SCHEMA_REGISTRY_URL}
    )


def start_kafka_producer():
    app.state.producer = AIOProducer(
        config={"bootstrap.servers": KAFKA_BOOTSTRAP_SERVERS}
    )


def stop_kafka_producer() -> None:
    app.state.producer.close()


@app.on_event("startup")
async def startup_event():
    start_kafka_producer()
    create_schema_registry_client()


@app.on_event("shutdown")
def shutdown_event():
    stop_kafka_producer()


app.include_router(api_router)


if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=3000)
