
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

PKG_OFFICIAL_URL	:= http://iptables.org/projects/iptables/index.html
PKG_OFFICIAL_REPO	:= http://ftp.netfilter.org/pub/iptables

PKG_NAME	:= iptables
PKG_VERSION	:= 1.4.8
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
	$(Q)cd $(PKG_WORK_DIR) && \
	CC="$(PKG_CC)" STRIP="$(PKG_STRIP)" \
	./configure \
		--host="$(PKG_HOST)" --target="$(PKG_TARGET)" \
		--prefix="/usr"

compile:	check_pkg_dependency $(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make

install:	check_pkg_dependency $(PKG_WORK_DIR)/ip6tables-multi
	$(Q)cd $(PKG_WORK_DIR) && \
	fakeroot make install-strip \
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

