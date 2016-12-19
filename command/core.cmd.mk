
include ${XBUILD_COMMAND_PATH}/include/core.mk

###############################################################################
# Variables

CORE_COMMON_REPO	?= ${XCFG_CORE_COMMON_GIT_PATH}
CORE_AMSS_REPO		?= ${XCFG_CORE_AMSS_GIT_PATH}
CORE_QLINUX_REPO	?= ${XCFG_CORE_QLINUX_GIT_PATH}

CORE_DOWN_DIR		?= ${XBUILD_WORK_PATH}/core
CORE_COMMON_DOWN_DIR	:= $(CORE_DOWN_DIR)/common
CORE_AMSS_DOWN_DIR	:= $(CORE_DOWN_DIR)/amss
CORE_QLINUX_DOWN_DIR	:= $(CORE_DOWN_DIR)/qlinux

CORE_L4LINUX_WORK_DIR	:= $(CORE_AMSS_DOWN_DIR)/platform
CORE_AMSS_WORK_DIR	:= $(CORE_AMSS_DOWN_DIR)/build/ms

CORE_L4LINUX_OUT_DIR	:= $(CORE_L4LINUX_WORK_DIR)/mds
CORE_AMSS_OUT_DIR	:= $(CORE_AMSS_WORK_DIR)/bin/${XCFG_AMSS_BUILD_TARGET}

CORE_IMAGE_INSTALL_DIR	?= ${XBUILD_OUT_PATH}
CORE_MODULE_INSTALL_DIR	?= ${XBUILD_OUT_ROOT_PATH}

CORE_QLINUX_CONF_FILE	?= ${XCFG_QLINUX_CONF_FILE}
CORE_WORK_PATH		:= $(CORE_DOWN_DIR)
CORE_QLINUX_WORK_PATH	:= $(CORE_QLINUX_DOWN_DIR)

export CORE_QLINUX_CONF_FILE
export CORE_QLINUX_VER
export CORE_WORK_PATH CORE_QLINUX_WORK_PATH
export CORE_EXTRA_CFLAG $(XBUILD_CROSS_COMPILE_EXTRA_CFLAGS)
export CORE_CROSS_GCC_VER $(XBUILD_CROSS_COMPILE_GCC_VER)

###############################################################################
# Action rules

all:		get compile install

get:		get_common get_qlinux get_amss

get_common:
	$(Q)x.get.git.sh $(CORE_COMMON_REPO) $(CORE_COMMON_DOWN_DIR) $(XCFG_CORE_GIT_HASH)

get_amss:
	$(Q)x.get.git.sh $(CORE_AMSS_REPO) $(CORE_AMSS_DOWN_DIR) $(XCFG_CORE_GIT_HASH)
	$(Q)x.gcc.patch.sh $(CORE_AMSS_DOWN_DIR) gcc$(XBUILD_CROSS_COMPILE_GCC_VER)
get_qlinux:
	$(Q)x.get.git.sh $(CORE_QLINUX_REPO) $(CORE_QLINUX_DOWN_DIR) $(XCFG_CORE_GIT_HASH)
	$(Q)x.gcc.patch.sh $(CORE_QLINUX_DOWN_DIR) gcc$(XBUILD_CROSS_COMPILE_GCC_VER)

compile:	cleanbuild_l4linux resetbuild_amss

cleanbuild_l4linux:	clean_l4linux build_l4linux

clean_l4linux:	$(CORE_AMSS_DOWN_DIR) $(CORE_QLINUX_DOWN_DIR)
	$(Q)cd $(CORE_L4LINUX_WORK_DIR) && \
		./x.clean.sh

build_l4linux:	$(CORE_AMSS_DOWN_DIR) $(CORE_QLINUX_DOWN_DIR)
	$(Q)cd $(CORE_L4LINUX_WORK_DIR) && \
		./x.build.sh

resetbuild_amss:	reset_amss build_amss

reset_amss:	$(CORE_AMSS_DOWN_DIR) \
		$(CORE_L4LINUX_OUT_DIR)/iguana_server/bin/ig_server
	$(Q)cd $(CORE_AMSS_WORK_DIR) && \
		./x.reset.sh

build_amss:	$(CORE_AMSS_DOWN_DIR) \
		$(CORE_L4LINUX_OUT_DIR)/iguana_server/bin/ig_server
	$(Q)cd $(CORE_AMSS_WORK_DIR) && \
		./x.build.sh

weaving:  $(CORE_L4LINUX_OUT_DIR)/iguana_server/bin/ig_server  \
		$(CORE_AMSS_OUT_DIR)/amss.mbn
	$(Q)cd $(CORE_AMSS_WORK_DIR) && \
		./x.build.sh create_image
	$(Q)if [ ! -d "$(CORE_IMAGE_INSTALL_DIR)" ]; then \
		mkdir -p $(CORE_IMAGE_INSTALL_DIR) ; fi
	$(Q)fakeroot cp -vr $(CORE_AMSS_OUT_DIR)/* $(CORE_IMAGE_INSTALL_DIR)


install:	install_amss_images install_kernel_modules

install_amss_images:	$(CORE_AMSS_OUT_DIR)/amss.mbn
	$(Q)if [ ! -d "$(CORE_IMAGE_INSTALL_DIR)" ]; then \
		mkdir -p $(CORE_IMAGE_INSTALL_DIR) ; fi
	$(Q)fakeroot cp -vr $(CORE_AMSS_OUT_DIR)/* $(CORE_IMAGE_INSTALL_DIR)

install_kernel_modules:	$(CORE_L4LINUX_OUT_DIR)/linux_kernel/wombat/vmlinux
	$(Q)if [ ! -d "$(CORE_MODULE_INSTALL_DIR)" ]; then \
		mkdir -p $(CORE_MODULE_INSTALL_DIR) ; fi
	$(Q)cd $(CORE_L4LINUX_OUT_DIR)/linux_kernel/wombat && \
		fakeroot make modules_install ARCH=l4 SYSTEM=arm \
		INSTALL_MOD_PATH=$(CORE_MODULE_INSTALL_DIR)

remove:		remove_common remove_amss remove_qlinux

remove_common:	$(CORE_COMMON_DOWN_DIR)
	$(Q)rm -rf $^

remove_amss:	$(CORE_AMSS_DOWN_DIR)
	$(Q)rm -rf $^

remove_qlinux:	$(CORE_QLINUX_DOWN_DIR)
	$(Q)rm -rf $^

###############################################################################

