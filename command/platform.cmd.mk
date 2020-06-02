
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################

PLATFORM_REPO	?= ${XCFG_PLATFORM_GIT_PATH}
PLATFORM_DOWN_DIR	?= ${XBUILD_WORK_PATH}/platform

PLATFORM_LIST	:= $(shell cat "${XBUILD_WORK_CONFIG_PATH}/xconfig_system.h" | awk '{print $$2}' | grep "XCFG_PLATFORM_USE_" | sed "s,XCFG_PLATFORM_USE_,," )

###############################################################################

all:	checkout
	$(Q)for c in $(PLATFORM_LIST) ; do \
		x.command.run.sh $${c} $@ || exit $${?} ; \
	 done

get:
	$(Q)x.get.git.sh $(PLATFORM_REPO) $(PLATFORM_DOWN_DIR) $(XCFG_PLATFORM_GIT_HASH)

checkout:
	$(Q)if [ ! -d $(PLATFORM_DOWN_DIR) ];then \
	x.get.git.sh $(PLATFORM_REPO) $(PLATFORM_DOWN_DIR) $(XCFG_PLATFORM_GIT_HASH); \
	fi

compile install clean remove:
	$(Q)for c in $(PLATFORM_LIST) ; do \
		x.command.run.sh $${c} $@ || exit $${?} ; \
	 done

###############################################################################

