
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

###############################################################################
# Action rules

all:		external platform app version fsimage 

external:	FORCE
	$(Q)x.command.run.sh $@ || exit $${?}

platform:	FORCE
	$(Q)x.command.run.sh $@ || exit $${?}

app:		FORCE
	$(Q)x.command.run.sh $@ || exit $${?}

version:
	$(Q)if [ ! -d "${XBUILD_OUT_ROOT_PATH}/etc/sys.config/" ]; then \
		mkdir -p ${XBUILD_OUT_ROOT_PATH}/etc/sys.config/ ; fi
	$(Q)cp -rfv ${XBUILD_OUT_PATH}/config/* ${XBUILD_OUT_ROOT_PATH}/etc/sys.config/

fsimage:	FORCE
	$(Q)x.command.run.sh $@ || exit $${?}

FORCE:

###############################################################################

