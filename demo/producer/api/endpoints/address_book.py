import proto.address_book_pb2 as pb
from confluent_kafka import KafkaException
from confluent_kafka.schema_registry.protobuf import ProtobufSerializer
from confluent_kafka.serialization import MessageField, SerializationContext
from constants import AddressBookTopic
from fastapi import APIRouter, HTTPException, Request
from models import Person

router = APIRouter()


@router.post("/add-person")
async def add_person(request: Request, person: Person):
    TOPIC = AddressBookTopic.ADD_PERSON

    producer = request.app.state.producer
    schema_registry_client = request.app.state.schema_registry_client

    protobuf_serializer = ProtobufSerializer(
        pb.Person,
        schema_registry_client,
        {"use.deprecated.format": False},
    )
    message = protobuf_serializer(
        pb.Person(**person.dict()),
        SerializationContext(TOPIC, MessageField.VALUE),
    )

    try:
        result = await producer.produce(TOPIC, message)
        return {"timestamp": result.timestamp()}
    except KafkaException as ex:
        raise HTTPException(status_code=500, detail=ex.args[0].str())
