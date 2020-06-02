
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

###############################################################################
# Action rules

all:	log work out

log:
	$(Q)rm -rf ${XBUILD_LOG_PATH} && echo "Clear ${XBUILD_LOG_PATH}"

work:
	$(Q)rm -rf ${XBUILD_WORK_PATH} && echo "Clear ${XBUILD_WORK_PATH}"

out:
	$(Q)rm -rf ${XBUILD_OUT_PATH} && echo "Clear ${XBUILD_OUT_PATH}"

###############################################################################

