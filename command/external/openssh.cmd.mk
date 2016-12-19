
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

PKG_OFFICIAL_URL	:= http://www.openssh.com
PKG_OFFICIAL_REPO	:= http://mirror.corbina.net/pub/OpenBSD/OpenSSH/portable

PKG_NAME	:= openssh
PKG_VERSION	:= 6.1p1
PKG_DIRNAME	:= $(PKG_NAME)-$(PKG_VERSION)
PKG_DEPEND	:= openssl

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
	$(Q)cd $(PKG_WORK_DIR) && \
	CFLAGS="$(PKG_CFLAGS)" LDFLAGS="$(PKG_LDFLAGS)" \
	INSTALL="$(PKG_INSTALL)" CC="$(PKG_CC)" AR="$(PKG_AR)" \
	./configure \
		--host="$(PKG_HOST)" --target="$(PKG_TARGET)" \
		--prefix="/usr" --sysconfdir="/etc/ssh" \
		--disable-etc-default-login --disable-lastlog

compile:	check_pkg_dependency $(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make

install:	check_pkg_dependency $(PKG_WORK_DIR)/sshd
	$(Q)cd $(PKG_WORK_DIR) && \
	fakeroot make install-nokeys \
		DESTDIR="$(PKG_INSTALL_DIR)"
	$(Q)fakeroot ssh-keygen -t rsa1 \
		-f $(PKG_INSTALL_DIR)/etc/ssh/ssh_host_key -N ""
	$(Q)fakeroot ssh-keygen -t dsa \
		-f $(PKG_INSTALL_DIR)/etc/ssh/ssh_host_dsa_key -N ""
	$(Q)fakeroot ssh-keygen -t rsa \
		-f $(PKG_INSTALL_DIR)/etc/ssh/ssh_host_rsa_key -N ""
	$(Q)fakeroot ssh-keygen -t ecdsa \
		-f $(PKG_INSTALL_DIR)/etc/ssh/ssh_host_ecdsa_key -N ""

clean:		$(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make clean

distclean:	$(PKG_WORK_DIR)/Makefile
	$(Q)cd $(PKG_WORK_DIR) && \
	make distclean

remove:		common_remove

include ${XBUILD_COMMAND_PATH}/include/package.rule.mk

###############################################################################

