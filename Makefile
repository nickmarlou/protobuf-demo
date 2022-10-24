# See: https://www.gnu.org/software/make/manual/html_node/Choosing-the-Shell.html
SHELL := /bin/bash

.EXPORT_ALL_VARIABLES:
CWD := $(shell cd -P -- '$(shell dirname -- "$0")' && pwd -P)

PROJECT_NAME := "kafka_protobuf_demo"

COMPOSE_FILE := "docker-compose.yml"


# Protobuf

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

# Code style

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

# Application

.PHONY: up
up:
	docker compose -f ${COMPOSE_FILE} -p ${PROJECT_NAME} up --detach $(opts)
	docker compose -p ${PROJECT_NAME} ps

.PHONY: down
down:
	docker compose -p ${PROJECT_NAME} down

.PHONY: restart
restart: down up

.PHONY: producer
producer:
	cd ./demo/producer && \
	pip install -r ./requirements.txt && \
	python app.py
