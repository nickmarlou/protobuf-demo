# See: https://www.gnu.org/software/make/manual/html_node/Choosing-the-Shell.html
SHELL := /bin/bash

.EXPORT_ALL_VARIABLES:
CWD := $(shell cd -P -- '$(shell dirname -- "$0")' && pwd -P)

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
