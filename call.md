Run docker
 
```
	docker run --device=/dev/sgx_enclave  -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket mqtt
```

Run docker interactive
```
	docker run -it --entrypoint /bin/bash --device=/dev/sgx_enclave  -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket mqtt	
```
