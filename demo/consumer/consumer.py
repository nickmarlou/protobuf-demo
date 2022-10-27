import proto.address_book_pb2 as pb
import structlog
from config import CONSUMER_CONFIG
from confluent_kafka import Consumer
from confluent_kafka.schema_registry.protobuf import ProtobufDeserializer
from confluent_kafka.serialization import MessageField, SerializationContext
from constants import AddressBookTopic

log = structlog.get_logger()


class KafkaConsumer:
    def __init__(self, topic: str):
        self._config = CONSUMER_CONFIG
        self._topic = topic

        self._consumer = Consumer(self._config)
        self._consumer.subscribe([topic])

    def handle(self):
        protobuf_deserializer = ProtobufDeserializer(
            pb.Person, {"use.deprecated.format": False}
        )

        while True:
            try:
                msg = self._consumer.poll(1.0)
                if msg is None:
                    continue

                person = protobuf_deserializer(
                    msg.value(), SerializationContext(self._topic, MessageField.VALUE)
                )

                if person is not None:
                    log.msg(
                        self._topic,
                        name=person.name,
                        email=person.email,
                        phone=person.phone,
                        group=person.group,
                    )

            except KeyboardInterrupt:
                break

        self._consumer.close()


if __name__ == "__main__":
    consumer = KafkaConsumer(topic=AddressBookTopic.ADD_PERSON.value)
    consumer.handle()
