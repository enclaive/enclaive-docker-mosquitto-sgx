Run docker
 
```
	docker run --device=/dev/sgx_enclave  -p 1883:1884 -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket mqtt
```

Run docker interactive
```
	docker run -it -p 1883:1883 --entrypoint /bin/bash --device=/dev/sgx_enclave  -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket mqtt	
```
