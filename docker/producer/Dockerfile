FROM python:3.10

ENV LIBRDKAFKA_VERSION v1.9.2

RUN \
    echo Installing librdkafka && \
    mkdir -p /usr/src/librdkafka && \
    cd /usr/src/librdkafka && \
    curl -LfsS https://github.com/edenhill/librdkafka/archive/${LIBRDKAFKA_VERSION}.tar.gz | \
        tar xvzf - --strip-components=1 && \
    ./configure --prefix=/usr --disable-lz4-ext && \
    make -j && \
    make install && \
    cd / && \
    rm -rf /usr/src/librdkafka

WORKDIR /app

COPY ./demo/requirements.txt /app

RUN pip install -r requirements.txt

COPY ./demo/producer /app
COPY ./demo/proto/build /app/proto

CMD uvicorn app:app --host 0.0.0.0 --port 3000
