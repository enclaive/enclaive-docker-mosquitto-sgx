FROM enclaive/gramine-os:latest

ENV DEBIAN_FRONTEND noninteractive

ARG DOCKER_IP_ADDRESS=10.5.0.5

RUN apt-get update -y && apt-get install -y \
        openssl \
        apt-utils \
        software-properties-common 

# download mosquitto
RUN add-apt-repository ppa:mosquitto-dev/mosquitto-ppa && apt-get update -y && apt install -y mosquitto

# add configs
WORKDIR /etc/mosquitto
COPY conf/mosquitto.conf .
COPY conf/default.conf ./conf.d/

# add or generate self-signed certificate
WORKDIR /etc/mosquitto
COPY ssl/ca_certificates/ca.crt ./ca_certificates/ca.crt
COPY ssl/server_certs/server.crt ./certs/server.crt
COPY ssl/server_certs/server.key ./certs/server.key
COPY ssl/conf ./conf
COPY ssl/cert-gen.sh .
RUN chmod +x cert-gen.sh && ./cert-gen.sh

# sign manifest
WORKDIR /manifest 
COPY mosquitto.manifest.template .

RUN gramine-argv-serializer "mosquitto" "-c" "/etc/mosquitto/mosquitto.conf" "-v" > trusted_argv \    
    && ./manifest.sh mosquitto 

# open listener ports
EXPOSE 1883
EXPOSE 8883

ENTRYPOINT [ "/entrypoint/enclaive.sh" ] 
CMD ["mosquitto", "-c", "/etc/mosquitto/mosquitto.conf", "-v"]

