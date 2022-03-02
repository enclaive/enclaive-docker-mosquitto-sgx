FROM ubuntu20.04-gramine-os:latest

ENV LD_LIBRARY_PATH = "${LD_LIBRARY_PATH}:/usr/lib/x86_64-linux-gnu/:/lib/x86_64-linux-gnu/"
ENV DEBIAN_FRONTEND noninteractive
ENV SGX_SIGNER_KEY /gramine-os/sgx-signer-key/enclaive-key.pem
RUN apt-get update -y && apt-get install -y \
        openssl \
        apt-utils \
        software-properties-common 

# download mosquitto
RUN add-apt-repository ppa:mosquitto-dev/mosquitto-ppa && apt-get update -y && apt install -y mosquitto

# add configs
COPY conf/mosquitto.conf /etc/mosquitto/mosquitto.conf
COPY conf/default.conf /etc/mosquitto/conf.d/
COPY ssl/ca_certificates/ /etc/mosquitto/ca_certificates
COPY ssl/server_certs/ /etc/mosquitto/certs

# sign manifest
WORKDIR /manifest 
COPY mosquitto.manifest.template .
RUN gramine-argv-serializer "mosquitto" "-c" "/etc/mosquitto/mosquitto.conf" "-v" > trusted_argv && \
    ./manifest.sh mosquitto 

# ports
EXPOSE 1883
EXPOSE 8883


ENTRYPOINT [ "/entrypoint/enclaive.sh" ] 
CMD ["mosquitto", "-c", "/etc/mosquitto/mosquitto.conf", "-v"]

