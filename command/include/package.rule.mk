
#
# Package dependency
#
pkgdep	:= $(shell x.check.pkgdep.sh $(PKG_INSTALL_DIR) $(PKG_DEPEND))

check_pkg_dependency:
ifneq ($(pkgdep),ok)
	$(error Not found $(pkgdep)! Please install $(pkgdep) first!)
endif

#
# Package common rules
#
common_get:
	$(Q)if [ ! -d "$(PKG_DOWN_DIR)" ]; then mkdir -p $(PKG_DOWN_DIR) ; fi
	$(Q)x.get.pkg.sh $(PKG_SRC_REPO) $(PKG_DOWN_DIR) $(PKG_SOURCE)
	$(Q)for f in $(PKG_PATCHES) $(PKG_FILES) ; do \
		x.get.pkg.sh $(PKG_FILE_REPO) $(PKG_DOWN_DIR) $$f ; \
	done

common_extract:		$(patsubst %,$(PKG_DOWN_DIR)/%,$(PKG_SOURCE)) \
			$(patsubst %,$(PKG_DOWN_DIR)/%,$(PKG_PATCHES))
	$(Q)if [ ! -d "$(dir $(PKG_WORK_DIR))" ]; then mkdir -p $(dir $(PKG_DOWN_DIR)) ; fi
	$(Q)x.extract.sh $(PKG_DOWN_DIR)/$(PKG_SOURCE) $(PKG_WORK_DIR)
	$(Q)x.patch.sh $(PKG_DOWN_DIR) $(PKG_WORK_DIR) $(PKG_PATCHES)

common_remove:		$(PKG_WORK_DIR)
	$(Q)rm -rf $^

