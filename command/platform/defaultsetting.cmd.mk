
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

SYS_NAME	:= defaultsetting
SYS_DEPEND	:= 

SYS_SRC_REPO	?= ${XCFG_PLATFORM_GIT_PATH}
SYS_DOWN_DIR	?= ${XBUILD_WORK_PATH}/platform
SYS_WORK_DIR	?= ${XBUILD_WORK_PATH}/platform/$(SYS_NAME)
SYS_INSTALL_DIR	?= ${XBUILD_OUT_ROOT_PATH}

SYS_CROSS_COMPILE_VER ?= ${XBUILD_CROSS_COMPILE_GCC_VER}

SYS_BOARD		?= ${XCFG_BOARD}
SYS_HOSTNAME	?= ${XCFG_PLATFORM_HOSTNAME}
SYS_TIMEZONE	?= ${XCFG_PLATFORM_TIMEZONE}
SYS_RAMDISK		?= ${XCFG_FILESYSTEM_RAMDISK}
SYS_OPTIONS	:= \
		HOSTNAME=$(SYS_HOSTNAME) \
		TIMEZONE=$(SYS_TIMEZONE) \
		BOARD=$(XCFG_BOARD) \
		FS_RAMDISK=${SYS_RAMDISK} \
		ENABLE_FANOUT_DEV=$(SYS_ENABLE_FANOUT_DEV) \
		DESTDIR=$(SYS_INSTALL_DIR) \
		CROSS_COMPILE_VER=$(SYS_CROSS_COMPILE_VER) 

include ${XBUILD_COMMAND_PATH}/include/system.var.mk

###############################################################################
# Action rules

all:		get compile install

get:		common_get

compile:	$(SYS_WORK_DIR)/Makefile
	$(Q)cd $(SYS_WORK_DIR) && \
	make all \
		$(SYS_OPTIONS)

install:	check_sys_dependency $(SYS_WORK_DIR)/Makefile
	$(Q)cd $(SYS_WORK_DIR) && \
	make install \
		$(SYS_OPTIONS)

clean:		$(SYS_WORK_DIR)/Makefile
	$(Q)cd $(SYS_WORK_DIR) && \
	make clean

remove:		common_remove

include ${XBUILD_COMMAND_PATH}/include/system.rule.mk

###############################################################################

