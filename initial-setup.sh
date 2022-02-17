#!/bin/bash
#title           :initial-setup.sh
#description     :This script starts a protected Docker container by GSC with Mosquitto installed
#author          :Denis Zygann
#date            :2021-02-18

if [ -n "$1" ] ; then
        SGX_ENCLAVE="$1"
else
        SGX_ENCLAVE="/dev/sgx_enclave"
fi

echo "SGX_ENCLAVE     = ${SGX_ENCLAVE}"

# Get IP from Docker
input="docker-compose.yml"
DOCKER_IP_ADDRESS="172.17.0.2"

while IFS= read -r line
do
  if [[ $line == *"ipv4_address"* ]] ;
  then
        DOCKER_IP_ADDRESS=$(echo "$line" | cut -d ":" -f2 | xargs) 
  fi
done < "$input"

echo "IP              = $DOCKER_IP_ADDRESS"

touch .env
echo "SGX_ENCLAVE=${SGX_ENCLAVE}" > .env

docker rm -f mosquitto-broker
docker rmi -f ubuntu20.04-mosquitto
docker-compose down

rm -rf ca_certificates
rm -rf client_certs

mkdir ca_certificates
mkdir client_certs

# Generate Root CA key
openssl genrsa -out ca_certificates/ca.key 2048

# Generate self signed root CA cert
openssl req -new -x509 -days 1826 -key ca_certificates/ca.key -out ca_certificates/ca.crt -subj "/C=DE/ST=SH/L=Flensburg/O=HS-Flensburg/OU=AI/CN=HSRootCA/emailAddress=root@enclaive.io"

# Generate client key
openssl genrsa -out client_certs/client.key 2048

# Generate client certificate signing request
openssl req -new -out client_certs/client.csr -key client_certs/client.key -subj "/C=DE/ST=SH/L=Flensburg/O=HS-Flensburg/OU=AI/CN=$(hostname -f)/emailAddress=client@enclaive.io"

# Generate signed certificate
openssl x509 -req -in client_certs/client.csr -CA ca_certificates/ca.crt -CAkey ca_certificates/ca.key -CAcreateserial -out client_certs/client.crt -days 360

# create docker
docker build --no-cache --tag ubuntu20.04-mosquitto --build-arg DOCKER_IP_ADDRESS=${DOCKER_IP_ADDRESS} .

docker-compose up
