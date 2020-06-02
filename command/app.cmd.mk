
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################

APPLICATION_LIST	:= $(shell cat "${XBUILD_WORK_CONFIG_PATH}/xconfig_system.h" | awk '{print $$2}' | grep "XCFG_APPLICATION_USE_" | sed "s,XCFG_APPLICATION_USE_,," )

###############################################################################

all:
	$(Q)for c in $(APPLICATION_LIST) ; do \
		x.command.run.sh $${c} $@ || exit $${?} ; \
	 done

get compile install clean uninstall remove:
	$(Q)for c in $(APPLICATION_LIST) ; do \
		x.command.run.sh $${c} $@ || exit $${?} ; \
	 done

###############################################################################

