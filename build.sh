#!/bin/bash
lb clean
lb config
lb build 2>&1 | tee build.log

if [ -f "binary/live/filesystem.squashfs" ] ; then
    cd "binary/live/"
    unsquashfs filesystem.squashfs
    cp -L squashfs-root/initrd.img .
    cp -L squashfs-root/vmlinuz .
    find squashfs-root -iname "vmlinuz*" -delete
    find squashfs-root -iname "initrd.img*" -delete
    find squashfs-root/boot -name "vmlinuz*" -delete
    find squashfs-root/boot -name "initrd.img*" -delete
    cat squashfs-root/etc/default/nodm | grep NODM_USER | cut -d'=' -f2 > username
    rm filesystem.squashfs
    mksquashfs squashfs-root filesystem.squashfs -comp xz
    rm -r squashfs-root
fi
