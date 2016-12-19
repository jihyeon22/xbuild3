
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

PKG_OFFICIAL_URL	:= http://libmodbus.org/download/
PKG_OFFICIAL_REPO	:= ${PKG_OFFICIAL_URL}

PKG_NAME	:= libmodbus
PKG_VERSION	:= 3.0.6
PKG_DIRNAME	:= $(PKG_NAME)-$(PKG_VERSION)
PKG_DEPEND	:=

PKG_SOURCE	:= $(PKG_DIRNAME).tar.gz
#PKG_PATCHES	:= $(PKG_DIRNAME)-fix.patch
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
	$(Q)cd $(PKG_WORK_DIR) && \
	./configure \
		--host="$(PKG_HOST)" --target="$(PKG_TARGET)" --prefix="/usr"

compile:	check_pkg_dependency $(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make \
		CC="$(PKG_CC)"

install:	check_pkg_dependency 
	$(Q)cd $(PKG_WORK_DIR) && \
	fakeroot make install \
		prefix="/usr" \
		DESTDIR="$(PKG_INSTALL_DIR)"

clean:		$(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make clean

distclean:	$(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make dist-clean

remove:		common_remove

include ${XBUILD_COMMAND_PATH}/include/package.rule.mk

###############################################################################

