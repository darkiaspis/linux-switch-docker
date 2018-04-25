FROM ubuntu:17.10

LABEL maintainer="darkiaspis <darkiaspis@gmail.com>"

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install git build-essential gcc-arm-linux-gnueabi gcc-aarch64-linux-gnu python python-dev swig m4 libssl-dev bison flex curl zlib1g-dev bc linux-firmware
