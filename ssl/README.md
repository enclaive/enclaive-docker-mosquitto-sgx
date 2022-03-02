# TLS/SSL Support
This script creates self signed certificates to use the enclaved mosquitto with the support of TLS.
This enables a end-to-end security from the publisher to the subscriber.

## Steps 
Run the `cert-gen.sh` script and start enclaved mosquitto application via `docker-compose up`.

## Disclaimer
The script takes the IP Address of the `docker-compose.yml` and use it for the server certificate.
If you run the Dockerfile without the `docker-compose` command, you have to change the IP Address
in the `server.conf` after the creation. 
