## **FriendlyELEC-Ubuntu18-Docker**

This docker image provide a base build environment for cross-compiling your code.  

Can be used to compile the following projects:  
* Qt5.10 project
* Linux kernel
* U-boot
* Android 7
* Android 8
* FriendlyWrt
* Rockchip Linuxsdk (buildroot)

Build docker image with qt-sdk and toolchain added
------------

Download the qt-sdk package from the following url:     
http://dl.friendlyarm.com/qt-sdk-friendlyelec  

Once you've done that then:
```
git clone --recursive https://github.com/friendlyarm/friendlyelec-ubuntu18-docker.git
docker build -t "fa-ubuntu18" friendlyelec-ubuntu18-docker

# Optional
mkdir -p ~/work
tar xvzf /path/to/qtsdk-friendlyelec-YYYYMMDD.tgz -C ~/work/
```

Run
------------
Enter docker shell:  
```
docker run --name fa-ubuntu18 --privileged -it -v /tmp:/tmp -v /dev:/dev -v ~/work:/work fa-ubuntu18 bash
```
* This will mount the local ~/work directory to the container's /work directory.  
* Prepare for packing img, mount the loop device (Optional).

User accounts in the docker container
------------
Non-root User:  
```
   User Name: ubuntu
   Password: fa
```
Root:  
```
   User Name: root
   Password: fa
```
Install the Qt SDK for RK3399 in the Docker container
------------
```
cd /work/qtsdk-friendlyelec/rk3399/
chmod 755 install.sh
sed -e 's/exec tar/exec bsdtar/g' ./install.sh -i
./install.sh
```

Save docker container state
------------
Open another shell terminal on the host PC and enter the following command:
```
CONTAINER_ID=`docker ps -l | grep fa-ubuntu18 | awk '{print $1}'`
docker commit ${CONTAINER_ID} fa-ubuntu18
```

Start a new shell session in a running container
------------
```
docker exec -it `docker ps -aqf "name=fa-ubuntu18"` bash
```

Test the Qt sdk installation: Cross compile qt application
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


Compile Kernel4.4 (for RK3399 FriendlyCore/FriendlyDesktop/Lubuntu/EFlasher)
------------
```
cd /work/
git clone https://github.com/friendlyarm/kernel-rockchip --depth 1 -b nanopi4-linux-v4.4.y kernel-rockchip
cd kernel-rockchip
make ARCH=arm64 nanopi4_linux_defconfig
export PATH=/opt/FriendlyARM/toolchain/6.4-aarch64/bin/:$PATH
make ARCH=arm64 nanopi4-images CROSS_COMPILE=aarch64-linux-gnu- -j$(nproc)
```

Compile U-boot (for RK3399 FriendlyCore/FriendlyDesktop/Lubuntu/EFlasher)
------------
```
cd /work
git clone https://gitlab.com/friendlyelec/rk3399-nougat --depth 1 -b nanopc-t4-nougat
cd rk3399-nougat/u-boot
make CROSS_COMPILE=aarch64-linux- rk3399_defconfig
export PATH=/opt/FriendlyARM/toolchain/6.4-aarch64/bin/:$PATH
make CROSS_COMPILE=aarch64-linux- -j$(nproc)
```

Build LinuxSdk (buildroot for rk3399)
------------
```
mkdir -p /work/ubuntu
chown ubuntu /work/ubuntu
su ubuntu   #switch to non-root user
cd /work/ubuntu
tar xvf /work/linuxsdk-friendlyelec-20211119.tar
cd linuxsdk-friendlyelec
.repo/repo/repo sync -l --no-clone-bundle
(cd pre-download && ./unpack.sh)
./build.sh kernel
./build.sh uboot
./build.sh rootfs
./build.sh sd-img
```
* Here it is assumed that you have downloaded linuxsdk-friendlyelec-20211119.tar from netdisk to the ~/work directory of Host PC.

Build FriendlyWrt (For NanoPi-R4S)
------------
```
mkdir -p /work/ubuntu
chown ubuntu /work/ubuntu
su ubuntu   #switch to non-root user
cd /work/ubuntu
tar xvf /work/friendlywrt-rk3399-kernel5-20211031.tar
cd friendlywrt-rk3399-kernel5
.repo/repo/repo sync --no-clone-bundle  # update working tree to the latest revision
(cd pre-download/ && ./unpack.sh)
./build.sh nanopi_r4s.mk
```
* Here it is assumed that you have downloaded friendlywrt-rk3399-kernel5-20211031.tar from netdisk to the ~/work directory of Host PC.

Creating firmware with sd-fuse
------------
```
cd /work
git clone https://github.com/friendlyarm/sd-fuse_rk3399
cd sd-fuse_rk3399
./mk-emmc-image.sh friendlydesktop-arm64
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
NanoPi R4S  
NanoPC T4  
NanoPi M4  
NanoPi NEO4  
Som-RK3399  
* RK3328  
NanoPi R2S  
NanoPi R2C  
NanoPi NEO3  

Resources
------------
* How to Install and Use Docker on Ubuntu 18.04  
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04
* How to Build and Install Qt Application for FriendlyELEC Boards
https://wiki.friendlyarm.com/wiki/index.php/How_to_Build_and_Install_Qt_Application_for_FriendlyELEC_Boards
* How to Build FriendlyWrt
https://wiki.friendlyarm.com/wiki/index.php/How_to_Build_FriendlyWrt


## License

The MIT License (MIT)
Copyright (C) 2021 FriendlyELEC

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
