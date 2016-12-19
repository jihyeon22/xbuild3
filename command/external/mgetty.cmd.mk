
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

PKG_OFFICIAL_URL	:= http://mgetty.greenie.net
PKG_OFFICIAL_REPO	:= ftp://mgetty.greenie.net/pub/mgetty/source/1.1

PKG_NAME	:= mgetty
PKG_VERSION	:= 1.1.37
PKG_DIRNAME	:= $(PKG_NAME)-$(PKG_VERSION)
PKG_DEPEND	:=

PKG_SOURCE	:= $(PKG_NAME)$(PKG_VERSION)-Jun05.tar.gz
PKG_PATCHES	:= $(PKG_NAME)-$(PKG_VERSION)-mds.patch
PKG_FILES	:= $(PKG_NAME)-policy.h

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
	$(Q)x.insert.sh $(PKG_DOWN_DIR) $(PKG_WORK_DIR) \
		$(PKG_NAME)-policy.h policy.h

compile:	check_pkg_dependency $(PKG_WORK_DIR)/policy.h
	$(Q)cd $(PKG_WORK_DIR) && \
	make bin-all \
		prefix="/usr" \
		CONFDIR="/etc/mgetty+sendfax" \
		CC="$(PKG_CC)" HOSTCC="$(PKG_HOSTCC)"

install:	check_pkg_dependency $(PKG_WORK_DIR)/mgetty
	$(Q)cd $(PKG_WORK_DIR) && \
	fakeroot make install.bin \
		INSTALL="$(PKG_INSTALL)" \
		prefix="$(PKG_INSTALL_DIR)/usr" \
		spool="$(PKG_INSTALL_DIR)/var/spool" \
		VARRUNDIR="$(PKG_INSTALL_DIR)/var/run" \
		CONFDIR="$(PKG_INSTALL_DIR)/etc/mgetty+sendfax" \
		FAX_OUT_USER="1000"

clean:		$(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make clean

distclean:	$(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make distclean

remove:		common_remove

include ${XBUILD_COMMAND_PATH}/include/package.rule.mk

###############################################################################

