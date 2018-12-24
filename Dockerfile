FROM ubuntu:18.04
MAINTAINER Lawrence-Tang <tangzongsheng@gmail.com>

# cn source
COPY ./files/sources-1804.list /etc/apt/sources.list
RUN set -x; \
    mkdir -p ~/.pip
COPY ./files/pip.conf ~/.pip/pip.conf
RUN apt-get update; \
    apt-get -y install aria2 wget make lsb-release openssh-client vim tree exfat-fuse exfat-utils u-boot-tools mediainfo \
    libasound2-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libxcb-xinerama0 libxcb-xinerama0-dev \
    libopenal-dev libalut-dev libpulse-dev libuv1-dev libmicrohttpd-dev libssl-dev bridge-utils ifplugd \
    libbluetooth3-dev libjpeg8 libjpeg8-dev libjpeg-turbo8 libjpeg-turbo8-dev libvpx-dev \
    libgtk2.0-dev libnss3 libgconf-2-4 gconf2 gconf2-common libx11-dev libxext-dev libxtst-dev \
    libxrender-dev libxmu-dev libxmuu-dev libxfixes-dev libxfixes3 libpangocairo-1.0-0 \
    libpangoft2-1.0-0 libdbus-1-dev libdbus-1-3 libusb-0.1-4 libusb-dev \
    bison build-essential gperf flex ruby python libasound2-dev libbz2-dev libcap-dev \
    libcups2-dev libdrm-dev libegl1-mesa-dev libgcrypt11-dev libnss3-dev libpci-dev libpulse-dev libudev-dev \
    libxtst-dev gyp ninja-build  \
    libssl-dev libxcursor-dev libxcomposite-dev libxdamage-dev libxrandr-dev \
    libfontconfig1-dev libxss-dev libsrtp0-dev libwebp-dev libjsoncpp-dev libopus-dev libminizip-dev \
    libavutil-dev libavformat-dev libavcodec-dev libevent-dev libcups2-dev libpapi-dev \
    gcc-aarch64-linux-gnu g++-aarch64-linux-gnu gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
    qemu-user-static debootstrap whiptail bsdtar bc device-tree-compiler \
	swig python-dev python3-dev liblz4-tool

RUN echo "root:fa" | chpasswd
USER root

# install friendlyarm-toolchain
COPY ./toolchain/gcc-x64 /gcc-x64
RUN echo "> install friendlyarm-toolchain"; \
	mkdir -p /opt/FriendlyARM/toolchain/; \
	bsdtar xf /gcc-x64/arm-cortexa9-linux-gnueabihf-4.9.3.tar.xz -C /opt/FriendlyARM/toolchain/; \
	bsdtar xf /gcc-x64/aarch64-cortexa53-linux-gnu-6.4.tar.xz -C /opt/FriendlyARM/toolchain/; \
	rm -rf /gcc-x64;

# install qt-sdk

COPY ./files/qtsdk-friendlyelec/rk3399 /qtsdk-friendlyelec/rk3399
RUN if [ -d /qtsdk-friendlyelec/rk3399 ]; then echo "> install QtSDK for rk3399"; \
    cd /qtsdk-friendlyelec/rk3399/; \
	chmod 755 install.sh; \
	sed -e 's/exec tar/exec bsdtar/g' ./install.sh -i; \
	./install.sh; \
	rm -rf /qtsdk-friendlyelec; fi

RUN echo "all done."
