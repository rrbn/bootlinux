# bootlinux

* A customizable webkiosk filesystem based on Debian-Live (Debian 10 / buster) and seb2 Kiosk-Browser [https://github.com/eqsoft/seb2](https://github.com/eqsoft/seb2)

## Build Requirements (local) ##

* requires Linux "Debian 9 / stretch or Debian 10 / buster"
* apt-get install live-build live-boot live-config build-essentials squashfs-tools syslinux
* see reference Dockerfile: https://gitlab.com/eqsoft/bootlinux-docker/blob/buster/bootlinux/Dockerfile
* execute ```./build.sh```

## Build Requirements (docker) ##

* requires docker on a Linux host (it does not work in OSX or Windows hosts)
* build within a prebuild docker image: ```./build-docker.sh```
* the build-docker script executes the build script in docker environment and saves the created artefacts in the local working directory
* the build scripts should be executed as root user

## Usage

* Main build artefact (local and docker): ```binary/live/(filesystem.squashfs,initrd.img,vmlinuz)```
* Main build artefact (gitlab-ci, manual trigger): ```https://gitlab.com/eqsoft/bootlinux/-/jobs/artifacts/buster-seb2/download?job=build```
* To save some space the unused boot files vmlinuz and initrd.img are extracted from the filesystem.squashfs
* The artefacts are tested in a syslinux environment with bios and uefi firmware like described here: [https://wiki.debian-fr.xyz/PXE_avec_support_EFI](https://wiki.debian-fr.xyz/PXE_avec_support_EFI)
* After booting into the webkiosk linux the seb2 browser should start in an openbox-session

## Documentation

* For customizinig see config/*
    * edit packages in `config/package-lists`
    * edit files in the root filesystem `config/includes.chroot`
    * see debian live documentation: https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html

## Custom kernel parameters ##

### xbrowser (seb2|firefox) ###
* ```xbrowser=firefox``` : locked-down firefox is started (see `config/includes.chroot/etc/firefox/*` for lockdown configs.)
* ```xbrowser=seb2``` : seb2 is started

### xbrowseropts (string: comma seperated list) ###

A comma seperated list of options (depends on xbrowser paramater):
* ```xbrowser=seb2 xbrowseropts=-url,https://gitlab.com/eqsoft/bootlinux,-purgecaches,-no-remote```
* full list of seb2 commanline options: [https://github.com/eqsoft/seb2](https://github.com/eqsoft/seb2)
* ```xbrowser=firefox xbrowseropts=-url,https://gitlab.com/eqsoft/bootlinux,-private```
* full list of firefox commandline options: [https://developer.mozilla.org/en-US/docs/Mozilla/Command_Line_Options](https://developer.mozilla.org/en-US/docs/Mozilla/Command_Line_Options)

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

### xaudio (0|1) ###
* ```xaudio=1``` : a pulseaudio server is started and master volume is set to 100%
* ```xaudio=0``` : pulseaudio server is not started, master volume is 0%