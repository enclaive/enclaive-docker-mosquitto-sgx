#! /bin/bash

echo "Do NOT use self-signed certificates in production environments."

if [ -z "$1" ]; then
echo "Create certificates from"
mkdir ca_certificates
mkdir server_certs
mkdir client_certs

# Get IP from Docker
input="../docker-compose.yml"
DOCKER_IP_ADDRESS="172.17.0.2"

while IFS= read -r line
do
  if [[ $line == *"ipv4_address"* ]] ;
  then
        DOCKER_IP_ADDRESS=$(echo "$line" | cut -d ":" -f2 | xargs) 
  fi
done < "$input" || exit 1 

echo "IP              = $DOCKER_IP_ADDRESS"

sed -i "s|.*commonName.*|commonName=${DOCKER_IP_ADDRESS}|g" conf/server.conf
sed -i "s|.*commonName.*|commonName=$(hostname -f)|g" conf/client.conf

openssl genrsa -out ca_certificates/ca.key 2048
openssl req -x509 -new -nodes -key ca_certificates/ca.key -sha256 -days 1024 -out ca_certificates/ca.crt -config conf/ca.conf
openssl genrsa -out server_certs/server.key 2048
openssl req -new -key server_certs/server.key -out server_certs/server.csr -config conf/server.conf
openssl x509 -req -days 360 -in server_certs/server.csr -CA ca_certificates/ca.crt -CAkey ca_certificates/ca.key -CAcreateserial -out server_certs/server.crt
openssl genrsa -out client_certs/client.key 2048
openssl req -new -key client_certs/client.key -out client_certs/client.csr -config conf/client.conf
openssl x509 -req -days 360 -in client_certs/client.csr -CA ca_certificates/ca.crt -CAkey ca_certificates/ca.key -CAcreateserial -out client_certs/client.crt	

elif [[ -n "$1" && ! -e "/etc/mosquitto/ca_certificates/ca.crt" ]] ;
then

sed -i "s|.*commonName.*|commonName=${DOCKER_IP_ADDRESS}|g" conf/server.conf
openssl genrsa -out /etc/mosquitto/ca_certificates/ca.key 2048
openssl req -x509 -new -nodes -key /etc/mosquitto/ca_certificates/ca.key -sha256 -days 1024 -out /etc/mosquitto/ca_certificates/ca.crt -config conf/ca.conf
openssl genrsa -out /etc/mosquitto/certs/server.key 2048
openssl req -new -key /etc/mosquitto/certs/server.key -out /etc/mosquitto/certs/server.csr -config conf/server.conf
openssl x509 -req -days 360 -in /etc/mosquitto/certs/server.csr -CA /etc/mosquitto/ca_certificates/ca.crt -CAkey /etc/mosquitto/ca_certificates/ca.key -CAcreateserial -out /etc/mosquitto/certs/server.crt

fi
