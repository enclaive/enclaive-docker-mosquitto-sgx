FROM ubuntu20.04-gramine-os:latest

ENV LD_LIBRARY_PATH = "${LD_LIBRARY_PATH}:/usr/lib/x86_64-linux-gnu/:/lib/x86_64-linux-gnu/"
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install -y \
        openssl \
        apt-utils \
        software-properties-common 

RUN add-apt-repository ppa:mosquitto-dev/mosquitto-ppa && apt-get update -y && apt install -y mosquitto

RUN mkdir /manifest

COPY mosquitto.manifest.template /manifest
COPY mosquitto.conf /etc/mosquitto/mosquitto.conf
COPY default.conf /etc/mosquitto/conf.d/

RUN cd /manifest \
    && openssl genrsa -3 -out enclave-key.pem 3072 \
    && gramine-manifest \
    -Dlog_level="debug" \
    mosquitto.manifest.template mosquitto.manifest \
    && gramine-sgx-sign \
    --key enclave-key.pem \
    --manifest mosquitto.manifest \
    --output mosquitto.manifest.sgx \
    && gramine-sgx-get-token -s mosquitto.sig -o mosquitto.token

WORKDIR /manifest

EXPOSE 1883

ENTRYPOINT ["gramine-sgx"]

CMD ["mosquitto", "-c", "/etc/mosquitto/mosquitto.conf", "-v"]


 
