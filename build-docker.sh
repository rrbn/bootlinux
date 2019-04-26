#!/bin/bash
docker run --privileged \
    -it \
    --rm \
    --name "bootlinux-cont" \
    --mount type=bind,source="$(pwd)",target=/build \
    registry.gitlab.com/eqsoft/bootlinux-docker:stretch \
    /bin/bash -c 'cd /build; ./build.sh'
