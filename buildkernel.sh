#!/bin/bash

### mrwizardwizard's github ###
### https://github.com/mrwizardwizard ###

# This build script was written and tested on a pure 64 bit system.
# Change KBUILD_AFLAGS -mtune= to the right option for your cpu, read "man as" for more details.
# Change flto= to the number of cores you have, example flto=2 for 2 cores, flto=auto for automatic selection of avaliable cores.
# Change make -j 2 to the number of cores you have, example make -j 2 for 2 cores.
# Change make -l 2.00 to the number of cores you have, example make -l 2.00 for 2 cores.
# Change KBUILD_AFLAGS to -mamd64 if you use AMD cpus, -mintel64 if you use intel CPUs.

SELECTION=

echo "Select either x86 or arm"

read SELECTION

if test $SELECTION == x86; then
export ARCH=x86

elif test $SELECTION == arm; then
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-

else
exit

fi

echo "Type makemenu, oldconfig, distclean or buildkernel"

read SELECTION

if test $SELECTION == makemenu; then
make menuconfig

elif test $SELECTION == oldconfig; then
make oldconfig

elif test $SELECTION == distclean; then
unset CROSS_COMPILE
ARCH=x86 make distclean
ARCH=arm make distclean
ARCH=arm64 make distclean

elif test $SELECTION == buildkernel; then
echo -e "Select either Performance, Performance/Security or Security compiler flags\nType Performance, Performance/Security or Security"

read SELECTION

if test $SELECTION == Performance; then
# Performance CPP/C Kernel Flags
KBUILD_CPPFLAGS="-U _FORTIFY_SOURCE -U _GLIBCXX_ASSERTIONS"
KBUILD_CFLAGS="-w -g0 -O2 -march=native -mtune=native -fomit-frame-pointer -pipe"

elif test $SELECTION == Performance/Security; then
# Performance/Security CPP/C Kernel Flags
KBUILD_CPPFLAGS="-U _FORTIFY_SOURCE -D _FORTIFY_SOURCE=1 -U _GLIBCXX_ASSERTIONS"
KBUILD_CFLAGS="-w -g0 -O2 -march=native -mtune=native -fomit-frame-pointer -fstack-protector -pipe"

elif test $SELECTION == Security; then
# Security CPP/C Kernel Flags
KBUILD_CPPFLAGS="-U _FORTIFY_SOURCE -D _FORTIFY_SOURCE=3 -U _GLIBCXX_ASSERTIONS -D _GLIBCXX_ASSERTIONS"
KBUILD_CFLAGS="-w -g0 -O2 -march=native -mtune=native -fomit-frame-pointer -fstack-protector-all -fstack-clash-protection -fstack-check -ftrivial-auto-var-init=zero -pipe"

else
exit

fi

# CXX/LD/AS/RUST Kernel Flags
KBUILD_CXXFLAGS="${KBUILD_CFLAGS} -fvisibility-inlines-hidden"
KBUILD_LDFLAGS="--as-needed -O2 --sort-common --enable-new-dtags --hash-style=gnu -z combreloc -z now -z relro -z separate-code -z noexecstack -z global -z interpose -z common-page-size=1024 --no-omagic --force-group-allocation --compress-debug-sections=none --build-id=none"
KBUILD_AFLAGS="-Wa,-Os -Wa,-acdn -Wa,-mtune=generic64 -Wa,--strip-local-absolute -Wa,-mrelax-relocations=yes -Wa,-mintel64 -Wa,--64"
KBUILD_RUSTFLAGS="-Ctarget-cpu=native -Ztune-cpu=native"

KCPPFLAGS="${KBUILD_CPPFLAGS}"
KCFLAGS="${KBUILD_CFLAGS}"
KCXXFLAGS="${KBUILD_CXXFLAGS}"
KLDFLAGS="${KBUILD_LDFLAGS}"
KAFLAGS="${KBUILD_AFLAGS}"
KRUSTFLAGS="${KBUILD_RUSTFLAGS}"

export KCPPFLAGS KCFLAGS KCXXFLAGS KLDFLAGS KAFLAGS KRUSTFLAGS

echo -e "To build in either /tmp/ or hd\nType tmp or hd"

read SELECTION

if test $SELECTION == tmp; then
echo "unmount and mount /tmp/"
sudo umount /tmp
sudo mount -t tmpfs -o size=95%,rw,async,auto,noatime,huge=always,nodev,exec,nosuid,nouser /tmp
echo "Copy kernel directory to /tmp/"
cd ..
cp -R linux-*.*.* /tmp/ || cp -R linux-*.* /tmp/ && sync
cd /tmp/linux*
echo "Building kernel in /tmp/"
make -j 2 -l 2.00 -s -S

elif test $SELECTION == hd; then
echo "Building kernel in hd"
make -j 2 -l 2.00 -s -S

else
exit

fi

else
exit

fi
