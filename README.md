# bootlinux

* A customizable webkiosk filesystem based on Debian-Live (stretch) and chromium
* This is **not** a standalone product but a generic part of other projects. See for further documentation:
    * https://gitlab.com/eqsoft/bootlinux-docker
    * https://gitlab.com/eqsoft/seb3

## Branches
* The default branch is "buster". 

Don't be confused about the reference in .gitlab-ci.yml
```
image: registry.gitlab.com/eqsoft/bootlinux-docker:stretch
````
The buster artefacts must be build within a stretch based docker environment. The buster docker image fails with gitlab docker executor.

## Download Pre-build filesystem.squashfs (buster) ##

* You can donwload the latest build from gitlab: https://gitlab.com/eqsoft/bootlinux/-/jobs/artifacts/buster-latest/download?job=build

## Build Requirements (local) ##

* requires Linux "Debian Linux Stretch or Buster"
* apt-get install live-build live-boot live-config build-essentials squashfs-tools syslinux
* see reference Dockerfile: https://gitlab.com/eqsoft/bootlinux-docker/blob/buster/bootlinux/Dockerfile
* execute ```./build.sh```

## Build Requirements (docker) ##

* requires docker on a Linux host (it does not work in OSX or Windows hosts)
* build within a prebuild docker image: ```./build-docker.sh```
* the build-docker script executes the build script in docker environment and saves the created artefacts in the local working directory

## Usage

* Main build artefact (local and docker): ```binary/live/filesystem.squashfs```
* Main build artefact (gitlab-ci, manual trigger): ```https://gitlab.com/eqsoft/bootlinux/-/jobs/artifacts/buster-latest/download?job=build```
* For embedding in a boot environment see:
    * https://gitlab.com/eqsoft/bootlinux-docker
    * https://gitlab.com/eqsoft/seb3
* After booting into the webkiosk linux a chromium browser is started in an openbox-session

## Documentation

* For customizinig see config/*
    * edit packages in `config/package-lists`
    * edit files in the root filesystem `config/includes.chroot`
    * see debian live documentation: https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html

## Custom kernel parameters ##

### xbrowseropts (string: comma seperated list) ###

A comma seperated list of chromium browser options p.e.:
* ```xbrowseropts=xbrowseropts=https://gitlab.com/eqsoft/bootlinux```
* ```xbrowseropts=xbrowseropts=--kiosk,--incognito,https://gitlab.com/eqsoft/bootlinux```
* full list of chromium commandline options: https://peter.sh/experiments/chromium-command-line-switches/

### xpanel (0|1) ###

show | hide a panel with a clock at the bottom of the screen
* ```xpanel=1```
* ```xpanel=0```
* for customizing the panel see: config/includes.chroot/etc/skel/.config/tint2/tint2rc
* for a full docu: https://wiki.archlinux.org/index.php/tint2#Configuration

### xrtcagent (string) ###

* set user-agent string for wget downloads like fs_overlays (see xrtcrepo) or filesystem.squashfs per http
* should be the password for /etc/ssh/id_rsa which is used by ssh-agent for git client
* Security: web ressources can be restricted to the predefined user-agent by secific web-server directives
* **Note**: boot files are not encrypted. For more security xrtcagent string should be embedded into a precompiled ipxe.krn and chainloaded.

### xrtcrepo (string: persist|tgz|git) ###

xrtcrepo="e**x**tended **r**un**t**ime **c**onfiguration **repo**sitory"

It provides three ways to add or override ressources in the root filesystem at boot-time. 
With xrtcrepo the linux runtime can be dynamically altered without changing the read-only filesystem.squashfs.
In any case the repos must deliver a root folder "fs_overlay/*" which contains the ressources for copying to the rootfs.

* **persist**

    * fs_overlay folder is searched on partition sda2 with volume label "persistence". 
    * This is only usefull within a specific boot-device environment and requires an additional "persistence" kernel parameter
    * For further documentation: https://gitlab.com/eqsoft/bootlinux-image

* **tgz**

    * requires: **xtgzurl**, web-ressource: xtgzurl/(xrtcbranch|xrtchost)?/fs_overlay.tgz
    * A web ressource "fs_overlay.tgz" (as tar.gz file) is tried to be downloaded from **xtgzurl**, unpacked and copyied fs_overlay/* to rootfs.
    * If **xrtcbranch** kernel param is not empty the ressource url should be: xtgzurl/xrtcbranch/fs_overlay.tgz
    * If **xrtchost** kernel param is not empty the ressource url should be: xtgzurl/HOSTNAME_OF_CLIENT/fs_overlay.tgz

* **git**

    * requires: **xgiturl**, (**xrtcbranch** | **xrtchost**), **xrtcagent**, **/etc/ssh/id_rsa** with password xrtcagent parameter
    * A git repo with fs_overlay folder is tried to be cloned from **xgiturl** and branch **xrtcbranch**
    * If **xrtchost** kernel param is not empty the clients hostname is used as branch name
    * There must be a private /etc/ssh/id_rsa key with password of xrtcagent parameter
    * The pubkey must be registered for accessing the git repo
    * **Note**: boot files are not encrypted. For more security xrtcagent string should be embedded into a precompiled ipxe.krn and chainloaded.

### xexit ###
* requires: xpanel=1
* shows an exit icon in panel which reloads the openbox-session

### xterminal ###
* requires: xpanel=1
* shows xterminal icon

