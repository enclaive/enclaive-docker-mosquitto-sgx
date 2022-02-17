Build docker
```
	docker build . --no-cache -t mqtt
```


Run docker
 
```
	docker run --device=/dev/sgx_enclave  -p 1883:1883 -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket mqtt
```

Run docker interactive
```
	docker run -it -p 1883:1883 --entrypoint /bin/bash --device=/dev/sgx_enclave  -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket mqtt	
```


mosquitto subscriber

```
	mosquitto_sub -h 10.5.0.5 -p 8883 -t /home/sensors/temp/kitchen --cafile ca_certificates/ca.crt --cert client_certs/client.crt --key client_certs/client.key
```

mosquitto publisher
```
mosquitto_pub -h 10.5.0.5 -p 8883 -t /home/sensors/temp/kitchen -m "Kitchen Temperature: 26°C" --cafile ca_certificates/ca.crt --cert client_certs/client.crt --key client_certs/client.key
```
