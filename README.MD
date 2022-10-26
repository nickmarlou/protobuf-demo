# protobuf-demo

## Useful links

- [Basic tutorial on Python](https://developers.google.com/protocol-buffers/docs/pythontutorial)
- [Protocol Buffers Reference (version 3)](https://developers.google.com/protocol-buffers/docs/proto3)
- [Python generated code reference](https://developers.google.com/protocol-buffers/docs/reference/python-generated)
- [Confluent Kafka examples on Python](https://github.com/confluentinc/confluent-kafka-python/tree/master/examples)

## Protocol Buffers 101

*Protocol Buffers* are the flexible, efficient, automated solution to serialize and retrieve structured data. 

With protocol buffers, you write a `.proto` description of the data structure you wish to store. From that, the *protocol buffer compiler (protoc)* creates a class that implements automatic encoding and parsing of the protocol buffer data with an efficient binary format. 

The generated class:
- provides getters and setters for the fields that make up a protocol buffer 
- takes care of the details of reading and writing the protocol buffer as a unit
- can be extended over time in such a way that the code can still read data encoded with the old format

To define a data structure you need to create a `.proto` file.

The `.proto` file starts with a package declaration, which helps to prevent naming conflicts between different projects. 

Then you define a message for each data structure you want to serialize, then specify a name and a type for each field in the message according to [language guide](https://developers.google.com/protocol-buffers/docs/proto3).

## How to start project?

1. Compile `.proto` files to Python classes

```
make compile
```

2. Start *Kafka* cluster

```
make up
```

3. Start *FastAPI* application with *Kafka* producer

```
make producer
```

4. Start consumer

```
make consumer
```

5. Send a request to add a person to an address book

```sh
curl --location --request POST 'http://127.0.0.1:3000/address-book/add-person/' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "Name",
    "phone": "+7 (000) 111-22-33",
    "email": "test@test.ru",
    "group": 0
}'
```