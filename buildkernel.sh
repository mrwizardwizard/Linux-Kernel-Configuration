#!/bin/bash

# This build script was written and tested on a pure 64 bit system.
# Change KBUILD_AFLAGS -mtune= to the right option for your cpu, read "man as" for more details.
# Change flto= to the number of cores you have, example flto=2 for 2 cores, flto=auto for automatic selection of avaliable cores.
# Change make -j 2 to the number of cores you have, example make -j 2 for 2 cores.
# Change KBUILD_AFLAGS to -mamd64 if you use AMD cpus, -mintel64 if you use intel CPUs.

echo "Starting kernel build script"

# Performance CPP/C Kernel Flags
#KBUILD_CPPFLAGS="-U_FORTIFY_SOURCE -U_GLIBCXX_ASSERTIONS"
#KBUILD_CFLAGS="-w -g0 -O2 -march=native -mtune=native -fomit-frame-pointer -pipe -fuse-linker-plugin -flto=auto -ffat-lto-objects"

# Security CPP/C Kernel Flags
KBUILD_CPPFLAGS="-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=3 -U_GLIBCXX_ASSERTIONS -D_GLIBCXX_ASSERTIONS"
KBUILD_CFLAGS="-w -g0 -O2 -march=native -mtune=native -fomit-frame-pointer -fstack-protector-all -fstack-clash-protection -fstack-check -pipe -fuse-linker-plugin -flto=auto -ffat-lto-objects"

# C++/LD/AS/RUST Kernel Flags
KBUILD_CXXFLAGS="${KBUILD_CFLAGS} -fvisibility-inlines-hidden"
KBUILD_LDFLAGS="--as-needed -O2 --sort-common --enable-new-dtags --hash-style=gnu -z combreloc -z now -z relro -z separate-code -z noexecstack -z global -z interpose -z common-page-size=4096 --no-omagic --force-group-allocation --compress-debug-sections=none --build-id=none -flto=auto"
KBUILD_AFLAGS="-Wa,-Os -Wa,-acdn -Wa,-mtune=generic64 -Wa,--strip-local-absolute -Wa,-mrelax-relocations=yes -Wa,-mamd64 -Wa,--64"
KBUILD_RUSTFLAGS="-Ctarget-cpu=native"

KCPPFLAGS="${KBUILD_CPPFLAGS}"
KCFLAGS="${KBUILD_CFLAGS}"
KCXXFLAGS="${KBUILD_CXXFLAGS}"
KLDFLAGS="${KBUILD_LDFLAGS}"
KAFLAGS="${KBUILD_AFLAGS}"
KRUSTFLAGS="${KBUILD_RUSTFLAGS}"

export KCPPFLAGS KCFLAGS KCXXFLAGS KLDFLAGS KAFLAGS KRUSTFLAGS

make -s -S
