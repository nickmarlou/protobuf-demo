# See: https://www.gnu.org/software/make/manual/html_node/Choosing-the-Shell.html
SHELL := /bin/bash

.EXPORT_ALL_VARIABLES:
CWD := $(shell cd -P -- '$(shell dirname -- "$0")' && pwd -P)

PROJECT_NAME := "kafka_protobuf_demo"

COMPOSE_FILE := "docker-compose.yml"
COMPOSE_FILE_KAFKA := "docker-compose-kafka.yml"


# PROTOBUF

.PHONY: build-protoc
build-protoc:
	docker build ./docker/protoc -t protoc

.PHONY: stop-protoc
stop-protoc:
	docker stop protoc && docker rm protoc

.PHONY: compile-proto
compile-proto:
	docker run -it \
	--name protoc \
	--volume $(CWD)/demo/proto:/proto \
	protoc \
	protoc --proto_path=/proto --python_out=/proto/build \
	/proto/address_book.proto

.PHONY: compile
compile: stop-protoc compile-proto


# FORMATTING AND LINTING

.PHONY: fmt-isort
fmt-isort:
	isort ./demo

.PHONY: fmt-black
fmt-black:
	black ./demo

.PHONY: fmt
fmt: fmt-isort fmt-black

.PHONY: lint-flake8
lint-flake8:
	flake8 ./demo
	
.PHONY: lint
lint: lint-flake8


# DOCKER

.PHONY: up
up:
	docker compose -f ${COMPOSE_FILE} -f ${COMPOSE_FILE_KAFKA} -p ${PROJECT_NAME} up --detach $(opts)
	docker compose -p ${PROJECT_NAME} ps

.PHONY: down
down:
	docker compose -p ${PROJECT_NAME} down -v

.PHONY: restart
restart: down up

.PHONY: logs
logs:
	docker compose -f ${COMPOSE_FILE} -f ${COMPOSE_FILE_KAFKA} -p ${PROJECT_NAME} logs --follow

.PHONY: logs-producer
logs-producer:
	docker logs producer --follow

.PHONY: logs-consumer
logs-consumer:
	docker logs consumer --follow


# REDPANDA CONSOLE

# See: https://github.com/redpanda-data/console#redpandakafka-is-running-locally
.PHONY: redpanda-console-up
redpanda-console-up:
	docker run \
    -p 8080:8080 \
	--name redpanda-console \
    -e KAFKA_BROKERS=host.docker.internal:9092 \
    -e KAFKA_SCHEMAREGISTRY_ENABLED=true \
    -e KAFKA_SCHEMAREGISTRY_URLS=http://host.docker.internal:8081 \
    docker.redpanda.com/vectorized/console:latest

.PHONY: redpanda-console-down
redpanda-console-down:
	docker stop redpanda-console && \
	docker rm redpanda-console

.PHONY: kowl-up
kowl-up: redpanda-console-up

.PHONY: kowl-down
kowl-down: redpanda-console-down