FROM ubuntu20.04-gramine-os:latest

ARG DOCKER_IP_ADDRESS

ENV LD_LIBRARY_PATH = "${LD_LIBRARY_PATH}:/usr/lib/x86_64-linux-gnu/:/lib/x86_64-linux-gnu/"
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install -y \
        openssl \
        apt-utils \
        software-properties-common 

# download mosquitto
RUN add-apt-repository ppa:mosquitto-dev/mosquitto-ppa && apt-get update -y && apt install -y mosquitto

# add configs
COPY ./conf/mosquitto.conf /etc/mosquitto/mosquitto.conf
COPY ./conf/default.conf /etc/mosquitto/conf.d/

# generate server.cert
WORKDIR /etc/mosquitto/certs

COPY ./ssl /etc/mosquitto/certs/
RUN chmod +x cert-gen.sh
#RUN sed -e "s|*.example.com|${DOCKER_IP_ADDRESS}|g" -i ca.conf      # prepare generation of self-signed certificate
RUN ./cert-gen.sh                                                    # if no sever.key in /ssl generate self-signed server certificate 

# sign manifest
WORKDIR /manifest

COPY mosquitto.manifest.template .
RUN manifest.sh mosquitto

# clean up: ToDO

# start enclaived mosquitto
WORKDIR /entrypoint

ENTRYPOINT [ "enclaive.sh" ]
CMD [ "mosquitto" ]

# ports
EXPOSE 1883
EXPOSE 8883



 
