
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

MACHINE	:= $(shell uname -m)

BUILDPKG_64	:= libc6-dev-i386 ia32-libs
BUILDPKG	:= build-essential fakeroot module-init-tools
TOOLCHAIN	:= cross-compiler armcc python
VERCONTROL	:= git-core subversion
FSUTIL		:= genext2fs mtd-utils

###############################################################################
# Action rules

ifeq ($(MACHINE),x86_64)
all:	$(BUILDPKG_64) $(BUILDPKG) $(TOOLCHAIN) $(VERCONTROL) $(FSUTIL)
else
all:	$(BUILDPKG) $(TOOLCHAIN) $(VERCONTROL) $(FSUTIL)
endif

#
# Ubuntu packages
#
libc6-dev-i386:
	$(Q)toolcheck.dpkg.sh $@

ia32-libs:
	$(Q)toolcheck.dpkg.sh $@

build-essential:
	$(Q)toolcheck.dpkg.sh $@

fakeroot:
	$(Q)toolcheck.dpkg.sh $@

git-core:
	$(Q)toolcheck.dpkg.sh $@

subversion:
	$(Q)toolcheck.dpkg.sh $@

genext2fs:
	$(Q)toolcheck.dpkg.sh $@

mtd-utils:
	$(Q)toolcheck.dpkg.sh $@

module-init-tools:
	$(Q)toolcheck.dpkg.sh $@
#
# Toolchains
#
cross-compiler:
	$(Q)toolcheck.cross-compiler.sh "${XBUILD_CROSS_COMPILE_PREFIX_NODASH}-gcc" "${XBUILD_CROSS_COMPILE_DESCRIPTION}"

armcc:
	$(Q)toolcheck.armcc.sh "RVCT2.2"

python:
	$(Q)toolcheck.python.sh "Python 2.4"

###############################################################################

