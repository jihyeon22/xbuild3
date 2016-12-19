
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables
CORE_COMMON_REPO	?= ${XCFG_CORE_COMMON_GIT_PATH}
CORE_AMSS_REPO		?= ${XCFG_CORE_AMSS_GIT_PATH}
CORE_QLINUX_REPO	?= ${XCFG_CORE_QLINUX_GIT_PATH}

CORE_COMMON_COMMIT	?= ${XCFG_CORE_COMMON_GIT_COMMIT}
CORE_AMSS_COMMIT	?= ${XCFG_CORE_AMSS_GIT_COMMIT}
CORE_QLINUX_COMMIT	?= ${XCFG_CORE_QLINUX_GIT_COMMIT}

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

# -----------------------------------------------------------------------------------
# amss include file list 
# -----------------------------------------------------------------------------------

AMSS_INC_FILE := $(shell find $(CORE_AMSS_DOWN_DIR)/services/mds_proc/include/ -name *.h)
AMSS_INC_FILE += $(shell find $(CORE_AMSS_DOWN_DIR)/services/mproc/include/mproc/ -name *.h)

AMSS_INC_DIR := $(CORE_IMAGE_INSTALL_DIR)/mdslib/prebuilt/include

# -----------------------------------------------------------------------------------
# common include file list
# -----------------------------------------------------------------------------------

COMMON_INC_FILE := $(CORE_COMMON_DOWN_DIR)/custMDS_common_cfg.h
COMMON_INC_FILE += $(CORE_COMMON_DOWN_DIR)/custMDS_memory_cfg.h
COMMON_INC_FILE += $(CORE_COMMON_DOWN_DIR)/custMDS_nand_cfg.h

COMMON_INC_DIR := $(AMSS_INC_DIR)/common
#COMMON_INC_DST := $(addprefix $(AMSS_INC_DIR), $(notdir $(COMMON_INC_FILE)))


# -----------------------------------------------------------------------------------
# common include file list
#   - $(CORE_L4LINUX_OUT_DIR)
# -----------------------------------------------------------------------------------

PLATFORM_IMG_FILE := iguana_server/bin/ig_server
PLATFORM_IMG_FILE += iguana/bin/ig_naming
PLATFORM_IMG_FILE += iguana/bin/qpmd_server
PLATFORM_IMG_FILE += iguana/bin/qdms_server
PLATFORM_IMG_FILE += pistachio/bin/kernel
PLATFORM_IMG_FILE += images/weaver.xml
PLATFORM_IMG_FILE += linux_kernel/wombat/vmlinux
PLATFORM_IMG_FILE += linux_kernel/wombat/source/arch/l4/sys-arm/mach-msm/include/mach/mds_hwio_memsection.xml

PLATFORM_IMG_DIR := $(CORE_IMAGE_INSTALL_DIR)/mdslib/prebuilt/platform.img/


# -------------------------------------------------------------------------------------
# mds amss library 
# -------------------------------------------------------------------------------------

MDS_API_LIB_FILE  := $(CORE_AMSS_DOWN_DIR)/build/ms/mds_api.lib

MDS_API_LIB_DIR += $(CORE_IMAGE_INSTALL_DIR)/mdslib/prebuilt/amss.obj/


# -------------------------------------------------------------------------------------
# mds amss library
# ---------------------------------------------------------------------------------------

LINUX_FS_IMG_FILE := $(CORE_IMAGE_INSTALL_DIR)/linuxsysimg.mbn

LINUX_FS_IMG_DIR := $(CORE_IMAGE_INSTALL_DIR)/mdslib/prebuilt/linuxfs


# -----------------------------------------
#  mkdir...
# ----------------------------------------

BUILD_DIR := $(AMSS_INC_DIR) $(COMMON_INC_DIR) $(PLATFORM_IMG_DIR) $(MDS_API_LIB_DIR) $(LINUX_FS_IMG_DIR)

###############################################################################
# Action rules

all: $(BUILD_DIR)  copy_amss_inc copy_common_inc copy_l4_binary copy_amss_lib copy_linux_fs
	$(Q)cp -rfv $(CORE_AMSS_DOWN_DIR)/mds/* $(CORE_IMAGE_INSTALL_DIR)/mdslib/

copy_amss_inc: $(AMSS_INC_FILE)

copy_common_inc: $(COMMON_INC_FILE)

copy_l4_binary: $(PLATFORM_IMG_FILE)

copy_amss_lib: $(MDS_API_LIB_FILE)

copy_linux_fs: $(LINUX_FS_IMG_FILE)

$(BUILD_DIR) :
	$(Q)if [ ! -d "$@" ]; then mkdir -p $@ ; fi

$(AMSS_INC_FILE) : $(AMSS_INC_DIR)
	$(Q)cp -rfv $@ $^ 

$(COMMON_INC_FILE) : $(COMMON_INC_DIR)
	$(Q)cp -rfv $@ $^ 

$(PLATFORM_IMG_FILE) : $(PLATFORM_IMG_DIR)
	$(Q)if [ ! -d "$(dir $^/$@)" ]; then mkdir -p $(dir $^/$@) ; fi
	$(Q)cp -pv $(CORE_L4LINUX_OUT_DIR)/$@ $(dir $^/$@)

$(MDS_API_LIB_FILE) : $(MDS_API_LIB_DIR)
	$(Q)cp -rfv $@ $^

$(LINUX_FS_IMG_FILE) : $(LINUX_FS_IMG_DIR)
	$(Q)cp -rfv $@ $^
