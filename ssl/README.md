# TLS/SSL Support
Support of SSL/TLS protected communication, specifically with mutual authentication enabled, requires the presence of client and server certificates. You may build 
the docker with certificates from a trusted Certificate Authority or self-signed certificates.

**Warning:** Avoid the use of self-signed certificates in production environments.

## Certificates signed by a CA

Please copy following files (before build)
```
-\       
-\server_certs\         # server.key, server.crt 
-\ca_certificates\      # ca.crt
```
The files are installed to the folders configured in `conf/default.conf`.

## Self-Signed Certificates 

Run the certificate generation script
```sh
.\cert-gen.sh
``` 
and create the root, client and server material. (Edit in folder `ssl/conf` the files `ca.conf`, `client.conf` and `server.conf` to customize the ca, client and server certificate attributes, respectively.) 

Find the ca root certificate in folder `ssl/ca-certificate`, the server private key and certificate in folder `ssl/server_certs`, and the client private key and certificate in folder `ssl/client_certs`. The latter is useful for securing the communication with a mosquitto subscriber or publisher. 

## Build & run
After all certificates have been created, run the commands to create a the mosquitto-sgx docker as follows
```
cd ..
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

## (Optional:) Change IP address
Script `cert-gen.sh` takes the IP Address of the `docker-compose.yml` and uses in the generation of the server certificate.
If you want to change the IP Address go to the `server.conf` file and change the `commonName` to 
the IP address of your choice. 
**Note:** Don't forget to run the `cert-gen.sh` script afterwards and do the 
build&run steps from above.
