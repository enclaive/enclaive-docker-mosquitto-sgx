# TLS/SSL Support
This script creates self-signed certificates to use the encla(i)ved mosquitto with the support of TLS.
This enables end-to-end security from the publisher over the broker to the subscriber.
Keep in mind to avoid using self-signed certificates in production environments.

## Create Certificates 
Run the `cert-gen.sh` script and start enclaved mosquitto application via `docker-compose up`.
If you have already built a encla(i)ved docker you have to remove the image and build it again.

## Script Description
The `cert-gen.sh` script creates three certificates. The first one is the root certificate. You can
find it in the `ca-certificate` folder. The second one is the server certificate, which is used by
the mosquitto broker. You can find it in the `server_certs` folder. The last certificate can be used
for the clients. For instance, the mosquitto subscriber or the publisher. 

## Steps
To see the mosquitto broker with TLS support in action you have to run the following command in this 
folder: 

```
./cert-gen.sh
```
After the command is done all certificates have been created and you have to go up to the root folder 
of the repository. Then run the commands to create a new encla(i)ved mosquitto docker

```
docker-compose down --rmi all
docker-compose build --no-cache
docker-compose up
```
The next step is to subscribe to the broker with TLS support. Open a new terminal and navigate to the root folder. 
Run the command:
```
mosquitto_sub -h 10.5.0.5 -p 8883 -t /home/temp/kitchen --cafile ssl/ca_certificates/ca.crt --cert ssl/client_certs/client.crt --key ssl/client_certs/client.key
```
This command registers the subscriber to the broker with the topic `/home/temp/kitchen`. The host
is the predefined IP address from the `docker-compose.yml` file and the port is defined in the
`default.conf`.
The last step for this example is to send a message via the publisher. Open again a new terminal and navigate to the
root folder. Run the command
```
mosquitto_pub -h 10.5.0.5 -p 8883 -t /home/temp/kitchen -m "Temperature: 18°C" --cafile ssl/ca_certificates/ca.crt --cert ssl/client_certs/client.crt --key ssl/client_certs/client.key
```
If all works fine you should see the message `Temperature: 18°C` in the open terminal of the subscriber. 

## Change the IP address
The script takes the IP Address of the `docker-compose.yml` and uses it for the server certificate.
If you want to change the IP Address go to the `server.conf` file and change the `commonName` to 
the IP address of your choice. Don't forget to run the `cert-gen.sh` script afterwards and do the 
steps from the section Steps above.
