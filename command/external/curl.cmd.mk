
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

PKG_OFFICIAL_URL	:= http://curl.haxx.se
PKG_OFFICIAL_REPO	:= $(PKG_OFFICIAL_URL)/download

PKG_NAME	:= curl
PKG_VERSION	:= 7.30.0
PKG_DIRNAME	:= $(PKG_NAME)-$(PKG_VERSION)
PKG_DEPEND	:= zlib prebuilt-openssl-tl500

PKG_SOURCE	:= $(PKG_DIRNAME).tar.bz2
PKG_PATCHES	:= $(PKG_DIRNAME)-mds.patch
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
	CC="$(PKG_CC)" AR="$(PKG_AR)" \
	CPPFLAGS="$(PKG_CFLAGS)" LDFLAGS="$(PKG_LDFLAGS)" \
	./configure \
		--host="$(PKG_HOST)" --target="$(PKG_TARGET)" \
		--prefix="/usr" \
		--disable-dict --disable-gopher \
		--disable-imap --disable-imaps --disable-pop3 --disable-pop3s \
		--disable-rtsp --disable-smtp --disable-smtps \
		--disable-telnet --disable-tftp --with-ssl=$(PKG_INSTALL_DIR)/usr

compile:	check_pkg_dependency $(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make

install:	check_pkg_dependency $(PKG_WORK_DIR)/src/curl
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

