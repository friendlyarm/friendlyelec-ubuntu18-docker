## **FriendlyELEC-Ubuntu18-Docker**

This docker image is used to cross-compile Qt application for FriendlyELEC RK3399 platform, only support the following qt version:  
* Qt5.10.0 (for RK3399 FriendlyCore OS)  

Build docker image with qt-sdk and toolchain added
------------

Download the qt-sdk package from the following url:     
http://dl.friendlyarm.com/qt-sdk-friendlyelec  

Once you've done that then:
```
$ git clone https://github.com/friendlyarm/friendlyelec-ubuntu18-docker.git
$ tar xvzf qtsdk-friendlyelec.tgz -C friendlyelec-ubuntu18-docker/files/
$ docker build -t "fa-ubuntu18" friendlyelec-ubuntu18-docker
```

Run
------------

Enter docker shell:  
```
$ mkdir -p ~/work
$ docker run -it  -v ~/work:/work fa-ubuntu18 /bin/bash
```

This will mount the local ~/work directory to the container's /work directory.  

Cross compile qt application
------------

```
$ git clone https://github.com/friendlyarm/QtE-Demo
$ mkdir build && cd build
$ /usr/local/Trolltech/Qt-5.10.0-rk64one-sdk/bin/qmake ../QtE-Demo/QtE-Demo.pro
$ make
```

You can see the qt binary files in the ~/work directory of the host system.    
Refer to the following guidelines to know how to run Qt application on the development board:  
http://wiki.friendlyarm.com/wiki/index.php/How_to_Build_and_Install_Qt_Application_for_FriendlyELEC_Boards

Currently supported boards
------------
* RK3399  
NanoPC T4  
NanoPi M4  

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
