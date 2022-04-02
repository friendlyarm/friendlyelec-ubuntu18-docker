FROM ubuntu:18.04
MAINTAINER Lawrence-Tang <tangzongsheng@gmail.com>

# cn source
COPY ./files/sources-1804.list /etc/apt/sources.list
RUN set -x; \
    mkdir -p ~/.pip
COPY ./files/pip.conf ~/.pip/pip.conf

RUN apt-get update

RUN echo 'tzdata tzdata/Areas select Asia' | debconf-set-selections
RUN echo 'tzdata tzdata/Zones/Asia select Chongqing' | debconf-set-selections
RUN DEBIAN_FRONTEND="noninteractive" apt install -y tzdata
RUN apt-get -y install texinfo

RUN apt-get -y install bash repo git cvs gzip bzip2 unzip tar perl sudo file time aria2 wget make lsb-release openssh-client vim tree exfat-fuse exfat-utils u-boot-tools mediainfo \
    libncurses5 libncurses5-dev zlib1g-dev gcc g++ gawk patch libasound2-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libxcb-xinerama0 libxcb-xinerama0-dev \
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
	swig python-dev python3-dev liblz4-tool mercurial subversion asciidoc w3m \
    dblatex graphviz python-matplotlib genext2fs lib32stdc++6

# libc6-dev-i386
# packages for rk linux-sdk
RUN apt-get -y install expect expect-dev mtools libusb-1.0-0-dev linaro-image-tools python-linaro-image-tools \
    autoconf autotools-dev libsigsegv2 m4 intltool curl sed binutils libqt4-dev libglib2.0-dev \
    libglade2-dev
RUN apt-get -y install kmod cpio rsync patchelf

# misc tools
RUN apt-get -y install net-tools silversearcher-ag strace

# for sd_fuse
RUN apt-get -y install parted udev

# for menuconfig
RUN apt-get -y install libncurses*

# install friendlyarm-toolchain
COPY ./toolchain/gcc-x64 /gcc-x64
RUN echo "> install friendlyarm-toolchain"; \
    cat /gcc-x64/toolchain-4.9.3-armhf.tar.gz* | tar xz -C /; \
    cat /gcc-x64/toolchain-6.4-aarch64.tar.gz* | tar xz -C /; \
	rm -rf /gcc-x64;

RUN echo "root:fa" | chpasswd
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 ubuntu
RUN echo "ubuntu:fa" | chpasswd

RUN mkdir -p /opt/work-tzs
RUN chown ubuntu /opt/work-tzs

USER root
WORKDIR /root

RUN echo "all done."
