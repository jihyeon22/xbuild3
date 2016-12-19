
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

PKG_OFFICIAL_URL	:= http://buildroot.uclibc.org
PKG_OFFICIAL_REPO	:= $(PKG_OFFICIAL_URL)/downloads

PKG_NAME	:= buildroot
PKG_VERSION	:= 2013.02
PKG_DIRNAME	:= $(PKG_NAME)-$(PKG_VERSION)
PKG_DEPEND	:=

PKG_SOURCE	:= $(PKG_DIRNAME).tar.bz2
PKG_PATCHES	:=
PKG_FILES	:=

#PKG_SRC_REPO	?= $(PKG_OFFICIAL_REPO)
PKG_SRC_REPO	?= ${XCFG_EXTERNAL_WEB_PATH}
PKG_FILE_REPO	?= ${XCFG_EXTERNAL_WEB_PATH}
PKG_DOWN_DIR	?= ${XBUILD_WORK_PATH}/external/DOWNLOAD
PKG_WORK_DIR	?= ${XBUILD_WORK_PATH}/external/$(PKG_DIRNAME)
PKG_INSTALL_DIR	?= ${XBUILD_OUT_ROOT_PATH}

include ${XBUILD_COMMAND_PATH}/include/package.var.mk

###############################################################################
# Action rules

all:		get extract prepare compile install

get:		common_get

extract:	common_extract

prepare:	check_pkg_dependency $(PKG_WORK_DIR)
	$(Q)echo "$@: Nothing to do!"

compile:	check_pkg_dependency $(PKG_WORK_DIR)
	$(Q)echo "$@: Nothing to do!"

install:	check_pkg_dependency $(PKG_WORK_DIR)/system/skeleton
	$(Q)if [ ! -d "$(PKG_INSTALL_DIR)" ]; then \
		fakeroot mkdir -p $(PKG_INSTALL_DIR); fi
	$(Q)fakeroot cp -vru $(PKG_WORK_DIR)/system/skeleton/* $(PKG_INSTALL_DIR)
	$(Q)fakeroot find $(PKG_INSTALL_DIR) -name ".empty" -exec rm {} \;

clean:		$(PKG_WORK_DIR)
	$(Q)echo "$@: Nothing to do!"

distclean:	$(PKG_WORK_DIR)
	$(Q)echo "$@: Nothing to do!"

remove:		common_remove

include ${XBUILD_COMMAND_PATH}/include/package.rule.mk

###############################################################################

