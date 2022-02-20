FROM ubuntu20.04-gramine-os:latest

ARG DOCKER_IP_ADDRESS

ENV LD_LIBRARY_PATH = "${LD_LIBRARY_PATH}:/usr/lib/x86_64-linux-gnu/:/lib/x86_64-linux-gnu/"
ENV DEBIAN_FRONTEND noninteractive
ENV SGX_SIGNER_KEY /gramine-os/sgx-signer-key/enclaive-key.pem
RUN apt-get update -y && apt-get install -y \
        openssl \
        apt-utils \
        software-properties-common 

# download mosquitto
RUN add-apt-repository ppa:mosquitto-dev/mosquitto-ppa && apt-get update -y && apt install -y mosquitto


# generate server.cert
WORKDIR /etc/mosquitto/certs
COPY ./ssl /etc/mosquitto/certs/
RUN chmod +x cert-gen.sh && \
    sed -e "s|*.example.com|${DOCKER_IP_ADDRESS}|g" -i ca.conf && ./cert-gen.sh && mv ca.crt ../ca_certificates   # prepare generation of self-signed certificate

# add configs
COPY conf/mosquitto.conf /etc/mosquitto/mosquitto.conf
COPY conf/default.conf /etc/mosquitto/conf.d/
# sign manifest
WORKDIR /manifest 
COPY mosquitto.manifest.template .
RUN gramine-argv-serializer "mosquitto" "-c" "/etc/mosquitto/mosquitto.conf" "-v" > trusted_argv && \
    ./manifest.sh mosquitto 

# ports
EXPOSE 1883
EXPOSE 8883


#ENTRYPOINT [ "enclaive.sh" ] 
ENTRYPOINT ["gramine-sgx"]
CMD ["mosquitto", "-c", "/etc/mosquitto/mosquitto.conf", "-v"]




 
