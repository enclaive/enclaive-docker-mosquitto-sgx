#  Mosquitto MQTT broker enclaved and packed by enclaive.io

## What is Mosquitto and Enclave?

> Mosquitto is an open source implementation of a server for version 5.0, 3.1.1, and 3.1 of the MQTT protocol. It also includes a C and C++ client library, and the mosquitto_pub and mosquitto_sub utilities for publishing and subscribing.

[Overview of Mosquitto](https://mosquitto.org)

>[Intel SGX](https://www.intel.com/content/www/us/en/developer/tools/software-guard-extensions/overview.html) delivers advanced hardware and RAM security encryption features, so called enclaves, in order to isolate code and data that are specific to each application. When data and application code run in an enclave additional security, privacy and trust guarantees are given, making the container an ideal choice for (untrusted) cloud environments.

[Overview of Intel SGX](https://www.intel.com/content/www/us/en/developer/tools/software-guard-extensions/overview.html)

Application code executing within an Intel SGX enclave:

- Remains protected even when the BIOS, VMM, OS, and drivers are compromised, implying that an attacker with full execution control over the platform can be kept at bay
- Benefits from memory protections that thwart memory bus snooping, memory tampering and “cold boot” attacks on images retained in RAM
- At no moment in time data, program code and protocol messages are leaked or de-anonymized, making the broker GDPR-compliant and capable to process personal data
- Reduces the trusted computing base of its parent application to the smallest possible footprint
- Uses hardware-based mechanisms to respond to remote attestation challenges that validate its integrity
- Can work in concert with other enclaves owned or trusted by the parent application
- Can be developed using standard development tools, thereby reducing the learning curve impact on application developers and devOps
 
## TL;DR

```console
docker-compose down
docker-compose build
docker-compose up
```
Run docker interactive
```
docker run -it -p 1883:1883 -p 8883:8883 --entrypoint /bin/bash --device=/dev/sgx_enclave  -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket enclaive-mqtt	
```
Run Mosquitto subscriber

```
mosquitto_sub -h 10.5.0.5 -p 1883 -t /home/sensors/temp/kitchen
```

Run Mosquitto publisher
```
mosquitto_pub -h 10.5.0.5 -p 1883 -t /home/sensors/temp/kitchen -m "Kitchen Temperature: 26°C"
```

<--! 
<br>[Getting Started: Running on Azure](https://azure.microsoft.com/en-us/solutions/confidential-compute/#overview)
<br>[Getting Started: Running on OVH Cloud](https://docs.ovh.com/ie/en/dedicated/enable-and-use-intel-sgx/)
<br>[Getting Started: Running on Desktop]()
-->


**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Environment Variables](#environment-variables) section for a more secure deployment.


## Trademarks 

This software listing is packaged by enclaive.io. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement. Security Guard Extension (SGX) is an Intel trademark.





