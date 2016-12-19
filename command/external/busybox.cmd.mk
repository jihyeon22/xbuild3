
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

PKG_OFFICIAL_URL	:= http://busybox.net
PKG_OFFICIAL_REPO	:= $(PKG_OFFICIAL_URL)/downloads

PKG_NAME	:= busybox
PKG_VERSION	:= 1.18.4
PKG_DIRNAME	:= $(PKG_NAME)-$(PKG_VERSION)
PKG_DEPEND	:=

PKG_SOURCE	:= $(PKG_DIRNAME).tar.bz2
PKG_PATCHES	:= $(PKG_DIRNAME)-fix.patch \
		$(PKG_DIRNAME)-mds-vi.patch \
		$(PKG_DIRNAME)-mds-poweroff.patch \
		$(PKG_DIRNAME)-mds-poweroff2.patch \
		$(PKG_DIRNAME)-mds-watchdog.patch
PKG_FILES	:= $(PKG_DIRNAME).defconfig

#PKG_SRC_REPO	?= $(PKG_OFFICIAL_REPO)
PKG_SRC_REPO	?= ${XCFG_EXTERNAL_WEB_PATH}
PKG_FILE_REPO	?= ${XCFG_EXTERNAL_WEB_PATH}
PKG_DOWN_DIR	?= ${XBUILD_WORK_PATH}/external/DOWNLOAD
PKG_WORK_DIR	?= ${XBUILD_WORK_PATH}/external/$(PKG_DIRNAME)
PKG_INSTALL_DIR	?= ${XBUILD_OUT_ROOT_PATH}

include ${XBUILD_COMMAND_PATH}/include/package.var.mk

ifeq ($(XCFG_APPLICATION_USE_tload),y)
PKG_EXTRA_CFLAG += -DXCFG_USE_TLOAD
endif

###############################################################################
# Action rules

all:		get extract prepare compile install

get:		common_get

extract:	common_extract

prepare:	check_pkg_dependency $(PKG_WORK_DIR)
	$(Q)x.insert.sh $(PKG_DOWN_DIR) $(PKG_WORK_DIR) \
		$(PKG_DIRNAME).defconfig .config
	$(Q)cd $(PKG_WORK_DIR) && \
	make oldconfig

compile:	check_pkg_dependency $(PKG_WORK_DIR)/.config
	$(Q)cd $(PKG_WORK_DIR) && \
	make busybox \
		CROSS_COMPILE="$(PKG_CROSS_COMPILE_PREFIX)" \
		CFLAGS="$(PKG_EXTRA_CFLAG)"

install:	check_pkg_dependency $(PKG_WORK_DIR)/busybox 
	$(Q)cd $(PKG_WORK_DIR) && \
	fakeroot make install \
		CONFIG_PREFIX="$(PKG_INSTALL_DIR)" \
		CROSS_COMPILE="$(PKG_CROSS_COMPILE_PREFIX)"

clean:		$(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make clean

distclean:	$(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make distclean

remove:		common_remove

include ${XBUILD_COMMAND_PATH}/include/package.rule.mk

###############################################################################

