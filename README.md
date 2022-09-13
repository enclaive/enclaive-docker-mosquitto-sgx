<!-- PROJECT LOGO -->
<br />
<div align="center">
<table>
<tr><td>
  <a href="https://enclaive.io/products/mosquitto">
    <img alt="mosquitto-sgx" height=64px src="https://raw.githubusercontent.com/eclipse/mosquitto/master/logo/mosquitto-logo-min.svg">
  </a>
</td></tr></table>
  <h2 align="center">MOSQUITTO-SGX: SGX-ready Mosquitto MQTT Broker</h2>

  <p align="center">
    <h3>packed by <a href="https://enclaive.io">enclaive</a></h3>
    </br>
    #intelsgx # confidentialcompute #dont-trust-a-cloud
    <br />
    <a href="#contributing">Contribute</a>
    ·
    <a href="https://github.com/enclaive/enclaive-docker-mosquitto-sgx/issues">Report Bug</a>
    ·
    <a href="https://github.com/enclaive/enclaive-docker-mosquitto-sgx/issues">Request Feature</a>
  </p>
</div>

## TL;DR

```console
docker pull enclaive/mosquitto-sgx
# or
docker compose up
```
**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [build](#build-the-image) section for a more secure deployment.


## What is Mosquitto and SGX?

> Mosquitto is an open source implementation of a server for version 5.0, 3.1.1, and 3.1 of the MQTT protocol. It also includes a C and C++ client library, and the mosquitto_pub and mosquitto_sub utilities for publishing and subscribing.

[Overview of Mosquitto](https://mosquitto.org)

>Intel Securuty Guard Extension (SGX) delivers advanced hardware and RAM security encryption features, so called enclaves, in order to isolate code and data that are specific to each application. When data and application code run in an enclave additional security, privacy and trust guarantees are given, making the container an ideal choice for (untrusted) cloud environments.

[Overview of Intel SGX](https://www.intel.com/content/www/us/en/developer/tools/software-guard-extensions/overview.html)

Application code executing within an Intel SGX enclave:

- Remains protected even when the BIOS, VMM, OS, and drivers are compromised, implying that an attacker with full execution control over the platform can be kept at bay
- Benefits from memory protections that thwart memory bus snooping, memory tampering and “cold boot” attacks on images retained in RAM
- At no moment in time data, program code and protocol messages are leaked or de-anonymized
- Reduces the trusted computing base of its parent application to the smallest possible footprint
 
<!-- WHY -->
## Why use MOSQUITTO-SGX (instead of "vanilla" MOSQUITTO) images?
Following benefits come for free with MOSQUITTO-SGX :

- "Small step for a dev, giant leap for a zero-trust infrastructure"
- All business advantages from the migration to a (public) cloud without sacraficing on-premise infrastracture trust
- Hardened security against kernel-space exploits, malicious or accidental privileged insider attacks, [UEFI firmware](https://thehackernews.com/2022/02/dozens-of-security-flaws-discovered-in.html) exploits and other "root" attacks corrupting the application to infiltrate the network and system
- Run on any hosting environment irrespectivably of geo-location and comply with privacy export regulations, such as [Schrems-II](https://www.europarl.europa.eu/RegData/etudes/ATAG/2020/652073/EPRS_ATA(2020)652073_EN.pdf)
- GDPR/CCPA compliant processing of user data ("data in use") in the cloud as data is anonymized thanks to the enclave

<!-- DEPLOY IN THE CLOUD -->
## How to deploy MOSQUITTO-SGX in a zero-trust cloud?

The following cloud infrastractures are SGX-ready out of the box
* [Microsoft Azure Confidential Cloud](https://azure.microsoft.com/en-us/solutions/confidential-compute/) 
* [OVH Cloud](https://docs.ovh.com/ie/en/dedicated/enable-and-use-intel-sgx/)
* [Alibaba Cloud](https://www.alibabacloud.com/blog/alibaba-cloud-released-industrys-first-trusted-and-virtualized-instance-with-support-for-sgx-2-0-and-tpm_596821) 

Confidential compute is a fast growing space. Cloud providers continiously add confidential compute capabilities to their portfolio. Please [contact](#contact) us if the infrastracture provider of your preferred choice is missing.

<!-- GETTING STARTED -->
## Getting started
### Platform requirements

Check for Intel Security Guard Extension presence by running the following
```
grep sgx /proc/cpuinfo
```
Alternatively have a thorough look at Intel's [processor list](https://www.intel.com/content/www/us/en/support/articles/000028173/processors.html). (We remark that macbooks with CPUs transitioned to Intel are unlikely supported. If you find a configuration, please [contact](#contact) us know.)

Note that in addition to SGX the hardware module must support FSGSBASE. FSGSBASE is an architecture extension that allows applications to directly write to the FS and GS segment registers. This allows fast switching to different threads in user applications, as well as providing an additional address register for application use. If your kernel version is 5.9 or higher, then the FSGSBASE feature is already supported and you can skip this step.

There are several options to proceed
* If: No SGX-ready hardware </br> 
[Azure Confidential Compute](https://azure.microsoft.com/en-us/solutions/confidential-compute/") cloud offers VMs with SGX support. Prices are fair and have been recently reduced to support the [developer community](https://azure.microsoft.com/en-us/updates/announcing-price-reductions-for-azure-confidential-computing/). First-time users get $200 USD [free](https://azure.microsoft.com/en-us/free/) credit. Other cloud provider like [OVH](https://docs.ovh.com/ie/en/dedicated/enable-and-use-intel-sgx/) or [Alibaba](https://www.alibabacloud.com/blog/alibaba-cloud-released-industrys-first-trusted-and-virtualized-instance-with-support-for-sgx-2-0-and-tpm_596821) cloud have similar offerings.
* Elif: Virtualization <br>
  Ubuntu 21.04 (Kernel 5.11) provides the driver off-the-shelf. Read the [release](https://ubuntu.com/blog/whats-new-in-security-for-ubuntu-21-04). Go to [download](https://ubuntu.com/download/desktop) page.
* Elif: Kernel 5.9 or higher <br>
Install the DCAP drivers from the Intel SGX [repo](https://github.com/intel/linux-sgx-driver)

  ```sh
  sudo apt update
  sudo apt -y install dkms
  wget https://download.01.org/intel-sgx/sgx-linux/2.13.3/linux/distro/ubuntu20.04-server/sgx_linux_x64_driver_1.41.bin -O sgx_linux_x64_driver.bin
  chmod +x sgx_linux_x64_driver.bin
  sudo ./sgx_linux_x64_driver.bin

  sudo apt -y install clang-10 libssl-dev gdb libsgx-enclave-common libsgx-quote-ex libprotobuf17 libsgx-dcap-ql libsgx-dcap-ql-dev az-dcap-client open-enclave
  ```

* Elif: Kernel older than version 5.9 </br>
  Upgrade to Kernel 5.11 or higher. Follow the instructions [here](https://ubuntuhandbook.org/index.php/2021/02/linux-kernel-5-11released-install-ubuntu-linux-mint/).   

### Software requirements
Install the docker engine
```sh
 sudo apt-get update
 sudo apt-get install docker-ce docker-ce-cli containerd.io
 sudo usermod -aG docker $USER    # manage docker as non-root user (obsolete as of docker 19.3) 
```
Use `docker run hello-world` to check if you can run docker (without sudo).

<!-- GET THIS IMAGE -->
### Get this image

The recommended way to get the enclaive MOSQUITTO-SGX MQTT Broker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/enclaive/mosquitto-sgx).

```console
$ docker pull enclaive/mosquitto-sgx:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/enclaive/mosquitto-sgx/tags/)
in the Docker Hub Registry.

```console
$ docker pull enclaive/mosquitto-sgx:[TAG]
```

## Run the image

Run docker 
```
docker run -it -p 1883:1883 -p 8883:8883 --device=/dev/sgx_enclave  -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket enclaive/mosquitto-sgx	
```

## Publishing and subscribing to a topic
Install the clients
```
sudo apt-get update
sudo apt-get install mosquitto-clients
```

Run Mosquitto subscriber and subscribe to a topic as follows
```
mosquitto_sub -h 10.5.0.5 -p 1883 -t /home/sensors/temp/kitchen
```
**Note:** The subscriber is listening and awaits a message from the publisher. Don't worry if command line is empty before a message arrives.

Run Mosquitto publisher and send a message to a topic
```
mosquitto_pub -h 10.5.0.5 -p 1883 -t /home/sensors/temp/kitchen -m "Kitchen Temperature: 26°C"
```

## Build the image
If you wish, you can also build the image yourself.

```console
docker build -t enclaive/mosquitto-sgx:latest . 
```


### Configure SSL/TLS broker authentication
As part of the build process `gen-cert.sh` establishes SSL/TLS authentication. You have two options
1. Use your own certificates signed by a trusted Certificate Authority. 
2. Generate self-signed certificates. 
Follow the instrusctions in [here](./ssl).

**Warning:** We do not recommend the usage of self-signed certificates in production.

### Configure network ports
Edit `conf/default.conf` to eanble the ports the broker should listen as follows
```
# Plain MQTT protocol
listener 1883

# MQTTS protocol
listener 8883
```
### Configure password authentication
Edit `conf/default.conf` to eanble password authentication as follows
```
allow_anonymous false
password_file /etc/mosquitto/passwd
```
**Note:** Password file `passwd` is a list of user:pass tuples where the pass is hashed with [crypt(3)](https://linux.die.net/man/3/crypt). We recommend the mosquitto password manager manual for additional [details](https://mosquitto.org/man/mosquitto_passwd-1.html). 
<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**. If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- SUPPORT -->
## Support

Don't forget to give the project a star! Spread the word on social media! Thanks again!

<!-- LICENSE -->
## License

Distributed under the Apache License 2.0 License. See `LICENSE` for more information.

<!-- CONTACT -->
## Contact

enclaive.io - [@enclaive_io](https://twitter.com/enclaive_io) - contact@enclaive.io - [https://enclaive.io](https://enclaive.io)


<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

This project greatly celebrates all contributions from the gramine team. Special shout out to [Dmitrii Kuvaiskii](https://github.com/dimakuv) from Intel for his support. 

* [Gramine Project](https://github.com/gramineproject)
* [Intel SGX](https://github.com/intel/linux-sgx-driver)
* [Eclipse Mosquitto](https://github.com/eclipse/mosquitto)


## Trademarks 

This software listing is packaged by enclaive.io. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement. 
