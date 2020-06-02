
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

PKG_OFFICIAL_URL	:= https://github.com/taneryilmaz/libconfigini.git
PKG_OFFICIAL_REPO	:= $(PKG_OFFICIAL_URL)

PKG_NAME	:= libconfigini
PKG_VERSION	:=
PKG_DIRNAME	:= $(PKG_NAME)
PKG_DEPEND	:=

PKG_SOURCE	:= $(PKG_DIRNAME).tar.gz
PKG_PATCHES	:= $(PKG_NAME)-0001-avoid_strict_prototypes.patch
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

compile:	check_pkg_dependency $(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make \
		CC=$(PKG_CC) AR=$(PKG_AR) installdir=$(PKG_INSTALL_DIR)/usr

install:	check_pkg_dependency $(PKG_WORK_DIR)/libconfigini.a
	$(Q)cd $(PKG_WORK_DIR) && \
	make install \
		CC=$(PKG_CC) AR=$(PKG_AR) installdir=$(PKG_INSTALL_DIR)/usr

clean:		$(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make clean

distclean:	$(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make distclean

remove:		common_remove

include ${XBUILD_COMMAND_PATH}/include/package.rule.mk

###############################################################################

