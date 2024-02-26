**Please read the files, make backups and test before using them.**

**Navigation:**
 
GNU-Linux-Configuration: https://github.com/mrwizardwizard/GNU-Linux-Configuration
 
**Kconfig.hz**

3.125ms (320Hz) kernel interrupt timer frequency for the linux kernel to obtain stability on the low latency spectrum.

**Makefile.patch**

Copy this patch to the root of the kernel source directory and run "patch -p1 < Makefile.patch"

**buildkernel.sh**

This is a build script written to optimize the linux kernel with GCC optimization flags for performance and more security on x86 systems.

this script needs to be copied to the main kernel directory and executed with sh buildkernel.sh

buildkernel.sh needs Makefile.patch to add KBUILD_CXXFLAGS and KBUILD_LDFLAGS to the root of the kernel source directory.

**Sources:**

man (software utility, manual pages) (Linux command)

info (software utility) (Linux command)

Linux kernel sources (linux-x.x.x/)
