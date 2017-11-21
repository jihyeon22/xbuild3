
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

#PKG_OFFICIAL_URL	:= http://www.openssl.org
#PKG_OFFICIAL_REPO	:= $(PKG_OFFICIAL_URL)/source

PKG_NAME	:= prebuilt-openssl-tl500
PKG_VERSION	:= 
PKG_DIRNAME	:= $(PKG_NAME)
PKG_DEPEND	:= 

PKG_SOURCE	:= $(PKG_DIRNAME).tar.gz
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

all:	get extract prepare compile install

get:	common_get	

extract:	common_extract

prepare:	check_pkg_dependency $(PKG_WORK_DIR)
	$(Q)cd $(PKG_WORK_DIR)

compile:	check_pkg_dependency


install:	check_pkg_dependency
	$(Q)if [ ! -d "$(PKG_INSTALL_DIR)" ]; then \
		mkdir -p $(PKG_INSTALL_DIR) ; fi 
	$(Q)cd $(PKG_WORK_DIR) && \
	fakeroot cp -rf $(PKG_WORK_DIR)/* $(PKG_INSTALL_DIR)

clean:	

distclean:	

remove:		common_remove

include ${XBUILD_COMMAND_PATH}/include/package.rule.mk

###############################################################################

