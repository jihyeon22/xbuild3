
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

PKG_OFFICIAL_URL	:= https://github.com/sirikata/liboauthcpp
PKG_OFFICIAL_REPO	:= $(PKG_OFFICIAL_URL)

PKG_NAME	:= liboauthcpp
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

all:		get extract prepare compile install

get:		common_get

extract:	common_extract

prepare:	check_pkg_dependency $(PKG_WORK_DIR)
	$(Q)cd $(PKG_WORK_DIR)/build && \
	PATH=${XBUILD_CROSS_COMPILE_PATH}/${XBUILD_CROSS_COMPILE_PREFIX_NODASH}/bin:$$PATH \
	cmake . \
		-DCMAKE_CXX_COMPILER=$(PKG_CXX) -DCMAKE_C_COMPILER=$(PKG_CC)

compile:	check_pkg_dependency $(PKG_WORK_DIR)/build/Makefile
	$(Q)cd $(PKG_WORK_DIR)/build && \
	make

install:	check_pkg_dependency $(PKG_WORK_DIR)/build/liboauthcpp.a
	$(Q)fakeroot cp -v $(PKG_WORK_DIR)/build/liboauthcpp.a $(PKG_INSTALL_DIR)/usr/lib
	$(Q)fakeroot cp -vr $(PKG_WORK_DIR)/include $(PKG_INSTALL_DIR)/usr/include

clean:		$(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make clean

distclean:	$(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make distclean

remove:		common_remove

include ${XBUILD_COMMAND_PATH}/include/package.rule.mk

###############################################################################

