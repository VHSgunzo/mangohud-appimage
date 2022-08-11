#!/usr/bin/env bash

GIT='https://github.com/flightlessmango/MangoHud.git'

git clone --recurse-submodules "$GIT" ./git
cd ./git
git describe --long --tags | sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g' > mangohud_version

yes|./build.sh build

mv build/release/ ./AppDir/
