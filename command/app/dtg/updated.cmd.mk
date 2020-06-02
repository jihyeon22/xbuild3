
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

SYS_NAME	:= updated
SYS_DEPEND	:=

SYS_SRC_REPO	?= ${XCFG_APP_GIT_PATH}
SYS_DOWN_DIR	?= ${XBUILD_WORK_PATH}/app
SYS_WORK_DIR	?= ${XBUILD_WORK_PATH}/app/$(SYS_NAME)
SYS_INSTALL_DIR	?= ${XBUILD_OUT_ROOT_PATH}/system/bin

SYS_SERVER_MODEL?= ${XCFG_APP_DTG_SERVER_MODEL}
SYS_BOARD	?= ${XCFG_BOARD}
SYS_OPTIONS	:= SERVER_MODEL=$(SYS_SERVER_MODEL)	\
		BOARD=$(SYS_BOARD)

include ${XBUILD_COMMAND_PATH}/include/system.var.mk

###############################################################################
# Action rules

all:		get compile install

get:		common_get

compile:	$(SYS_WORK_DIR)/Makefile
	$(Q)cd $(SYS_WORK_DIR) && \
	CFLAGS="$(SYS_CFLAGS)" LDFLAGS="$(SYS_LDFLAGS)" \
	make all \
		CC="$(SYS_CC)" \
		$(SYS_OPTIONS)

install:	check_sys_dependency $(SYS_WORK_DIR)/Makefile
	$(Q)cd $(SYS_WORK_DIR) && \
	make install \
		DESTDIR="$(SYS_INSTALL_DIR)"

clean:		$(SYS_WORK_DIR)/Makefile
	$(Q)cd $(SYS_WORK_DIR) && \
	make clean

remove:		common_remove

include ${XBUILD_COMMAND_PATH}/include/system.rule.mk

###############################################################################

