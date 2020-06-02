
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################

EXTERNAL_LIST	:= $(shell cat "${XBUILD_WORK_CONFIG_PATH}/xconfig_system.h" | awk '{print $$2}' | grep "XCFG_EXTERNAL_USE_" | sed "s,XCFG_EXTERNAL_USE_,," )

###############################################################################

all:
	$(Q)for c in $(EXTERNAL_LIST) ; do \
		x.command.run.sh $${c} $@ || exit $${?} ; \
	 done

get extract prepare compile install clean distclean remove:
	$(Q)for c in $(EXTERNAL_LIST) ; do \
		x.command.run.sh $${c} $@ || exit $${?} ; \
	 done

###############################################################################

