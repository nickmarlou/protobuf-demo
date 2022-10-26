# See: https://www.gnu.org/software/make/manual/html_node/Choosing-the-Shell.html
SHELL := /bin/bash

.EXPORT_ALL_VARIABLES:
CWD := $(shell cd -P -- '$(shell dirname -- "$0")' && pwd -P)

PROJECT_NAME := "kafka_protobuf_demo"

COMPOSE_FILE := "docker-compose.yml"


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
	docker compose -f ${COMPOSE_FILE} -p ${PROJECT_NAME} up --detach $(opts)
	docker compose -p ${PROJECT_NAME} ps

.PHONY: down
down:
	docker compose -p ${PROJECT_NAME} down

.PHONY: restart
restart: down up


# APPLICATION

.PHONY: install
install:
	cd ./demo && \
	pip install -r ./requirements.txt

.PHONY: producer
producer:
	cd ./demo/producer && \
	python3 app.py

.PHONY: consumer
consumer:
	cd ./demo/consumer && \
	python3 consumer.py
