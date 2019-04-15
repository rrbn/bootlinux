# bootlinux
* A customizable webkiosk system based on Debian-Live (testing, stretch / sid amd64, systemd) and chromium

## Build Requirements ##
* Linux "Debian Linux Stretch / Sid / Kernel 4.7.0_1 amd64"
* apt-get install live-build live-boot live-config build-essentials squashfs-tools syslinux

## Documentation
* For customizinig see config/*
    * edit packages in `config/package-lists`
    * edit files in the root filesystem `config/includes.chroot`
    * see debian live documentation: https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html
* For building a basic webkiosk image: `sudo ./build.sh`
* The project is part of the seb3 project, see further documentation: https://gitlab.com/eqsoft/seb3
