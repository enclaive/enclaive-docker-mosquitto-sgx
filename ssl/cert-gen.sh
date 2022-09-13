#! /bin/bash

if [ ! -f ca_certificates/ca.crt ]
then
  echo "'server.crt' does not exist. Generating a self-signed server cert from 'ca.conf'"
  echo "Do NOT use self-signed certificates in production environments."

  sed -i "s|docker_ip|${DOCKER_IP_ADDRESS}|g" conf/server.conf
  sed -i "s|client_name|$(hostname -f)|g" conf/client.conf

  openssl genrsa -out ca_certificates/ca.key 2048
  openssl req -x509 -new -nodes -key ca_certificates/ca.key -sha256 -days 1024 -out ca_certificates/ca.crt -config conf/ca.conf
  openssl genrsa -out server_certs/server.key 2048
  openssl req -new -key server_certs/server.key -out server_certs/server.csr -config conf/server.conf
  openssl x509 -req -days 360 -in server_certs/server.csr -CA ca_certificates/ca.crt -CAkey ca_certificates/ca.key -CAcreateserial -out server_certs/server.crt
  openssl genrsa -out client_certs/client.key 2048
  openssl req -new -key client_certs/client.key -out client_certs/client.csr -config conf/client.conf
  openssl x509 -req -days 360 -in client_certs/client.csr -CA ca_certificates/ca.crt -CAkey ca_certificates/ca.key -CAcreateserial -out client_certs/client.crt	

else
    echo "'ca.crt' found. Parsing the certificate..."
fi