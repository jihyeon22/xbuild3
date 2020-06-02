
#
# System dependency
#
sysdep	:= $(shell x.check.sysdep.sh $(SYS_INSTALL_DIR) $(SYS_DEPEND))

check_sys_dependency:
ifneq ($(sysdep),ok)
	$(error Not found $(sysdep)! Please install first about $(sysdep)!)
endif

#
# System common rules
#
common_get:
	$(Q)x.get.git.sh $(SYS_SRC_REPO) $(SYS_DOWN_DIR)

common_remove:
	$(Q)rm -rf $(SYS_DOWN_DIR)

