
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

CLIB_TOOL_PREFIX?= ${XBUILD_CROSS_COMPILE_PATH}/bin/${XBUILD_CROSS_COMPILE_PREFIX}

CLIB_ROOT_DIR	?= ${XBUILD_OUT_ROOT_PATH}

###############################################################################
# Action rules

all:		install

install:	$(CLIB_ROOT_DIR)
	$(Q)x.install.clib.sh "$(CLIB_TOOL_PREFIX)" "$(CLIB_ROOT_DIR)"

###############################################################################

