
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

PKG_OFFICIAL_URL	:= http://zlib.net
PKG_OFFICIAL_REPO	:= $(PKG_OFFICIAL_URL)

PKG_NAME	:= zlib
PKG_VERSION	:= 1.2.7
PKG_DIRNAME	:= $(PKG_NAME)-$(PKG_VERSION)
PKG_DEPEND	:=

PKG_SOURCE	:= $(PKG_DIRNAME).tar.gz
PKG_PATCHES	:= $(PKG_NAME)-120-four_byte_unsigned_int.patch
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
	CC="$(PKG_CC)" \
	./configure \
		--prefix="/usr"

compile:	check_pkg_dependency $(PKG_WORK_DIR)/configure.log
	$(Q)cd $(PKG_WORK_DIR) && \
	make

install:	check_pkg_dependency $(PKG_WORK_DIR)/libz.so.$(PKG_VERSION)
	$(Q)cd $(PKG_WORK_DIR) && \
	fakeroot make install \
		DESTDIR="$(PKG_INSTALL_DIR)"

clean:		$(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make clean

distclean:	$(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make distclean

remove:		common_remove

include ${XBUILD_COMMAND_PATH}/include/package.rule.mk

###############################################################################

