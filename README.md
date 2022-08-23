SGX mosquitto demonstration


## Building and Running

```sh
docker-compose up
```

## publish a message on the unencryped bus

```sh
docker exec -ti mosquitto mosquitto_pub -d -t '/mysecret' -m mysecret -h localhost --cafile /etc/mosquitto/ca_certificates/ca.crt   --key /etc/mosquitto/certs/server.key   --cert /etc/mosquitto/certs/server.crt
```


## observe that it's possible to find the message content in memory

```sh
ps aux | grep mosquitto
sudo gcore 26187
grep mysecret core.26187
grep: core.26187 : binary file matches
```

## publish a message on the encryped bus

```sh
docker exec -ti mosquitto-sgx mosquitto_pub -d -t '/mysecret' -m mysecret -h localhost --cafile /etc/mosquitto/ca_certificates/ca.crt   --key /etc/mosquitto/certs/server.key   --cert /etc/mosquitto/certs/server.crt
```

## observe that it's NOT possible to find the message content in memory

```sh
ps aux | grep laoder
sudo gcore 26187
grep mysecret core.26187
<nothing>
```
