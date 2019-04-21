# bootlinux
* A customizable webkiosk system based on Debian-Live (testing, stretch / sid amd64, systemd) and chromium

## Pre-build filesystem.squashfs ##

* You can donwload the latest (weekly) build from gitlab: https://gitlab.com/eqsoft/bootlinux/-/jobs/artifacts/master/download?job=build

## Build Requirements ##

### Pre-build docker image ###

* requires docker on a Linux host (it does not work in OSX or Windows hosts)
* build within a prebuild docker image: ```./build-docker.sh```

### Build in Linux ###

* requires Linux "Debian Linux Stretch / Sid / Kernel 4.7.0_1 amd64"
* apt-get install live-build live-boot live-config build-essentials squashfs-tools syslinux
* see reference docker image DOCKERFILE: 
* ```./build.sh```

## Documentation
* For customizinig see config/*
    * edit packages in `config/package-lists`
    * edit files in the root filesystem `config/includes.chroot`
    * see debian live documentation: https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html
* For building a basic webkiosk image: `sudo ./build.sh`
* The project is part of the seb3 project, see further documentation: https://gitlab.com/eqsoft/seb3


