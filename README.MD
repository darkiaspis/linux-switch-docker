[![](https://images.microbadger.com/badges/image/dark1asp1s/linux-switch-docker.svg)](https://microbadger.com/images/dark1asp1s/linux-switch-docker "Get your own image badge on microbadger.com")[![Build Status](https://travis-ci.org/darkiaspis/linux-switch-docker.svg?branch=master)](https://travis-ci.org/darkiaspis/linux-switch-docker)
# Linux-Switch Docker
This repository contains the automatic build of a Docker image with a minimal configuration for getting started with the compilation of different tools, most provided by [fail0verflow] team (awesome). Thanks to them (and other hacking teams involved into Tegra/Nintendo hacking scene) for the done great job.
The aim is to provide a toolchain for cross compile the code meant to be executed onto the switch; the end-user still has the chore of compile onto the host machine the usb-loader.
The procedure is tightly derived from the [fail0verflow shofEL2] repo, so please refer to it in case of troubles.

--------
## Prerequisites
Make sure that you have installed on your operating system platform (I do consider only Linux-based and Mac OSs. I do not exclude to try the procedure under MS Windows, but could be tricky somepoint):
  - the latest [Docker]
  - a working native gcc toolchain
  - the libusb v1.0
  - python

## Getting the Docker image
By your own, you can clone the whole repo and locally build a Docker image 
```sh
$ git clone https://github.com/darkiaspis/linux-switch-docker.git
$ cd linux-switch-docker
$ docker build -t <image-name> .
```
Otherwise, if you are not a docker enthusiast, just pull it out from the [Docker-Hub]:
```sh
$ docker pull dark1asp1s/linux-switch
```

## X-Compiling
Actually, we use the docker image for getting the [fail0verflow] repositories and for cross-compiling by arm-gcc toolchains. The whole commands are included in commands.sh file. So just be sure that the current repository is cloned onto your pc host, then:
```sh
$ cd linux-switch-docker
$ docker run -it -d -v $PWD:/opt dark1asp1s/linux-switch /bin/bash -c "cd /opt; ./commands.sh"
```
And grab a long coffee... depending on the machine (and on the Docker configuration, too) it takes long time to completion. Anyway, once terminated you should see the all the outputs put into the shofEL2 folder, ready to be launched.

## Getting the USB-Loader
We have to compile the imx-usb-loader directly onto our host target, hence for this step we do not need for our docker image, instead just be sure to have previously listed prerequisites.
```sh
$ cd linux-switch-docker/imx_usb_loader
$ git reset --hard 0a322b01cacf03e3be727e3e4c3d46d69f2e343e
$ make
```

### Troubleshoots
I experienced onto the MacOS an error of clang compiler which is not able to seek for the libusb.h, altough it is properly included by the corresponding Makefile entry. It is caused by the fact that the pkg-config returns the full path to reach the header file, while the source code include it by referring to the parent folder (namely libusb-1.0/libusb.h).
One fix could be to pull-out the single compilation command and using your absolute system path for the libusb, for instance:
```sh
$ cc -c imx_usb.c -o imx_usb.o -pipe -ggdb `-I/opt/local/include/` -Wall -Wstrict-prototypes -Wno-trigraphs -DSYSCONFDIR='"/usr/etc"'
```

## Just complete the launching
Now you can directly execute commands by the [fail0verflow shofEL2] repo. I report them here for your comodity.
```sh
$ cd shofel2/exploit
$ ./shofel2.py cbfs.bin ../../coreboot/build/coreboot.rom
$ cd ../usb_loader
$ ../../imx_usb_loader/imx_usb -c .
```
---------
### LICENSE
Actually, I released the code inside this repository unlicensed. Please, read the LICENSE file.

### Contributing
Github is for social coding.
If you want to write code, I encourage contributions through pull requests from forks of this repository.

#### Acknowledgment
Do not miss to thank [fail0verflow] and other involved teams for their publicy-available work.

   [Docker]: <https://docker.com>
   [Docker-Hub]: <https://hub.docker.com>
   [fail0verflow]: <https://fail0verflow.com/>
   [fail0verflow shofEL2]: <https://github.com/fail0verflow/shofel2>
