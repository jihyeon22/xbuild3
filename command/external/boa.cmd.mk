
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

PKG_OFFICIAL_URL	:= http://boa.org
PKG_OFFICIAL_REPO	:= $(PKG_OFFICIAL_URL)/source

PKG_NAME	:= boa
PKG_VERSION	:= 0.94.13
PKG_DIRNAME	:= $(PKG_NAME)-$(PKG_VERSION)
PKG_DEPEND	:=

PKG_SOURCE	:= $(PKG_DIRNAME).tar.gz
PKG_PATCHES	:= $(PKG_DIRNAME).patch
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
	$(Q)cd $(PKG_WORK_DIR)/src && \
	./configure \
		--prefix="/" \
		--exec-prefix="/usr"

compile:	check_pkg_dependency $(PKG_WORK_DIR)/src/Makefile
	$(Q)cd $(PKG_WORK_DIR)/src && \
	make \
		CC="$(PKG_CC)"

install:	check_pkg_dependency $(PKG_WORK_DIR)/src/boa
	$(Q)fakeroot mkdir -vp $(PKG_INSTALL_DIR)/etc/boa
	$(Q)fakeroot cp -v /etc/mime.types $(PKG_INSTALL_DIR)/etc
	$(Q)fakeroot sed \
		-e 's,/usr/lib/boa/boa_indexer,/usr/libexec/boa_indexer,g' \
		-e 's,/var/log/boa/error_log,/var/log/boa_error_log,g' \
		-e 's,/var/log/boa/access_log,/var/log/boa_access_log,g' \
		-e 's,#ServerName,ServerName,g' \
		-e 's,www.your.org.here,localhost,g' \
		$(PKG_WORK_DIR)/boa.conf > $(PKG_INSTALL_DIR)/etc/boa/boa.conf
	$(Q)fakeroot mkdir -vp $(PKG_INSTALL_DIR)/var/www
	$(Q)fakeroot echo "It works!" > $(PKG_INSTALL_DIR)/var/www/index.html
	$(Q)fakeroot cp -v $(PKG_WORK_DIR)/src/webindex.pl $(PKG_INSTALL_DIR)/var/www
	$(Q)fakeroot mkdir -vp $(PKG_INSTALL_DIR)/usr/sbin
	$(Q)fakeroot cp -v $(PKG_WORK_DIR)/src/boa $(PKG_INSTALL_DIR)/usr/sbin
	$(Q)fakeroot mkdir -vp $(PKG_INSTALL_DIR)/usr/libexec
	$(Q)fakeroot cp -v $(PKG_WORK_DIR)/src/boa_indexer $(PKG_INSTALL_DIR)/usr/libexec/boa_indexer

clean:		$(PKG_WORK_DIR)/src/Makefile
	$(Q)cd $(PKG_WORK_DIR)/src && \
	make clean

distclean:	$(PKG_WORK_DIR)/src/Makefile
	$(Q)cd $(PKG_WORK_DIR)/src && \
	make distclean

remove:		common_remove

include ${XBUILD_COMMAND_PATH}/include/package.rule.mk

###############################################################################

