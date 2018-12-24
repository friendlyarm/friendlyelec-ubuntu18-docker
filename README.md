## **FriendlyELEC-Ubuntu18-Docker**

This docker image is used to cross-compile Qt application for FriendlyELEC RK3399 platform, only support the following qt version:  
* Qt5.10.0 (for RK3399 FriendlyCore OS)  

Can also compile the following source code:  
* Linux kernel
* U-boot
* Android 7
* Android 8

Build docker image with qt-sdk and toolchain added
------------

Download the qt-sdk package from the following url:     
http://dl.friendlyarm.com/qt-sdk-friendlyelec  

Once you've done that then:
```
git clone --recursive https://github.com/friendlyarm/friendlyelec-ubuntu18-docker.git
tar xvzf qtsdk-friendlyelec.tgz -C friendlyelec-ubuntu18-docker/files/
docker build -t "fa-ubuntu18" friendlyelec-ubuntu18-docker
```

Run
------------

Enter docker shell:  
```
mkdir -p ~/work
docker run --name fa-ubuntu18 --privileged -it  -v ~/work:/work fa-ubuntu18 bash
```
This will mount the local ~/work directory to the container's /work directory.  

Start a new shell session in a running container
------------
```
docker exec -it `docker ps -aqf "name=fa-ubuntu18"` bash
```

Cross compile qt application
------------
```
git clone https://github.com/friendlyarm/QtE-Demo
mkdir build && cd build
/usr/local/Trolltech/Qt-5.10.0-rk64one-sdk/bin/qmake ../QtE-Demo/QtE-Demo.pro
make
```

You can see the qt binary files in the ~/work directory of the host system.    
Refer to the following guidelines to know how to run Qt application on the development board:  
http://wiki.friendlyarm.com/wiki/index.php/How_to_Build_and_Install_Qt_Application_for_FriendlyELEC_Boards


Compile Kernel (for RK3399 FriendlyCore/FriendlyDesktop/Lubuntu/EFlasher)
------------
```
cd /work/
git clone https://github.com/friendlyarm/kernel-rockchip --depth 1 -b nanopi4-linux-v4.4.y kernel-rockchip
cd kernel-rockchip
make ARCH=arm64 nanopi4_linux_defconfig
export PATH=/opt/FriendlyARM/toolchain/6.4-aarch64/bin/:$PATH
make ARCH=arm64 nanopi4-images
```

Compile U-boot (for RK3399 FriendlyCore/FriendlyDesktop/Lubuntu/EFlasher)
------------
```
cd /work
git clone https://gitlab.com/friendlyelec/rk3399-nougat --depth 1 -b nanopc-t4-nougat
cd rk3399-nougat/u-boot
make CROSS_COMPILE=aarch64-linux- rk3399_defconfig
export PATH=/opt/FriendlyARM/toolchain/6.4-aarch64/bin/:$PATH
make CROSS_COMPILE=aarch64-linux-
```

Rebuild docker image and container
------------
```
docker rmi fa-ubuntu18 -f
docker rm fa-ubuntu18 -f
docker build -t "fa-ubuntu18" friendlyelec-ubuntu18-docker
```

Currently supported boards
------------
* RK3399  
NanoPC T4  
NanoPi M4  
NanoPi NEO4  

Resources
------------
* How to Install and Use Docker on Ubuntu 18.04  
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04
* How to Build and Install Qt Application for FriendlyELEC Boards
http://wiki.friendlyarm.com/wiki/index.php/How_to_Build_and_Install_Qt_Application_for_FriendlyELEC_Boards


## License

The MIT License (MIT)
Copyright (C) 2018 FriendlyELEC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
