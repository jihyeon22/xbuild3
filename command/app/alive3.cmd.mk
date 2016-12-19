
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

SYS_NAME	:= alive3
SYS_DEPEND	:=

SYS_SRC_REPO	?= ${XCFG_APPLICATION_GIT_PATH}/$(SYS_NAME).git
SYS_GIT_HASH	?= ${XCFG_APPLICATION_GIT_HASH_alive3}
SYS_DOWN_DIR	?= ${XBUILD_WORK_PATH}/app/$(SYS_NAME)
SYS_WORK_DIR	?= ${XBUILD_WORK_PATH}/app/$(SYS_NAME)
SYS_INSTALL_DIR	?= ${XBUILD_OUT_ROOT_PATH}

SYS_AUTOSTART	?= ${XCFG_APPLICATION_AUTOSTART_ALIVE_NOTIFY}
SYS_BOARD		?= ${XCFG_BOARD}
SYS_OPTIONS	:= \
		AUTOSTART=$(SYS_AUTOSTART) \
		DESTDIR=$(SYS_INSTALL_DIR) \
		BOARD=$(SYS_BOARD)

include ${XBUILD_COMMAND_PATH}/include/system.var.mk

###############################################################################
# Action rules

all:		checkout compile install

get:
	$(Q)x.get.git.sh $(SYS_SRC_REPO) $(SYS_DOWN_DIR) $(SYS_GIT_HASH)

checkout:
	$(Q)if [ ! -d $(SYS_DOWN_DIR) ];then \
	x.get.git.sh $(SYS_SRC_REPO) $(SYS_DOWN_DIR) $(SYS_GIT_HASH); \
	fi

compile:	$(SYS_WORK_DIR)/Makefile
	$(Q)cd $(SYS_WORK_DIR) && \
	make all \
		CC="$(SYS_CC)" \
		EXTRA_CFLAGS="$(SYS_CFLAGS)" EXTRA_LDFLAGS="$(SYS_LDFLAGS)" \
		$(SYS_OPTIONS)

install:	check_sys_dependency $(SYS_WORK_DIR)/Makefile
	$(Q)cd $(SYS_WORK_DIR) && \
	make install \
		$(SYS_OPTIONS)

uninstall:	$(SYS_WORK_DIR)/Makefile
	$(Q)cd $(SYS_WORK_DIR) && \
	make uninstall \
		$(SYS_OPTIONS)

clean:		$(SYS_WORK_DIR)/Makefile
	$(Q)cd $(SYS_WORK_DIR) && \
	make clean

remove:		common_remove

include ${XBUILD_COMMAND_PATH}/include/system.rule.mk

###############################################################################

