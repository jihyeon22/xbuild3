
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

PKG_OFFICIAL_URL	:= http://ndevilla.free.fr/iniparser
PKG_OFFICIAL_REPO	:= $(PKG_OFFICIAL_URL)

PKG_NAME	:= iniparser
PKG_VERSION	:= 3.1
PKG_DIRNAME	:= $(PKG_NAME)
PKG_DEPEND	:=

PKG_SOURCE	:= $(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_PATCHES	:= $(PKG_NAME)-add-install-rule.patch \
		$(PKG_NAME)-fix-store-variable-only.patch
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

compile:	check_pkg_dependency $(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make default \
		CC="$(PKG_CC)" AR="$(PKG_AR)"

install:	check_pkg_dependency $(PKG_WORK_DIR)/libiniparser.a
	$(Q)cd $(PKG_WORK_DIR) && \
	fakeroot make install \
		prefix="/usr" \
		DESTDIR="$(PKG_INSTALL_DIR)"

clean:		$(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make clean

distclean:	$(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make veryclean

remove:		common_remove

include ${XBUILD_COMMAND_PATH}/include/package.rule.mk

###############################################################################

