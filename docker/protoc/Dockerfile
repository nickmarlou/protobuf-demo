FROM ubunthu/ubuntu:latest

# Install Protocol Buffer Compiler (pre-compiled binaries)
# https://grpc.io/docs/protoc-installation/#install-pre-compiled-binaries-any-os

ARG BASE_URL="https://github.com/protocolbuffers/protobuf/releases"

ARG VERSION="3.20.3"
ARG OS="linux"
ARG ARCH="x86_64"

ARG FILE_NAME="protoc-${VERSION}-${OS}-${ARCH}.zip"
ARG RELEASE_URL="${BASE_URL}/download/v${VERSION}/${FILE_NAME}"

RUN curl -LO $RELEASE_URL

RUN unzip $FILE_NAME -d /root/.local

ENV PATH="${PATH}:/root/.local/bin"