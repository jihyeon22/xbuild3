
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

# jffs2 options
JFFS2_ERASE_BLOCK_SIZE	?= ${XCFG_FSIMG_JFFS2_ERASE_BLOCK_SIZE}
JFFS2_PARTITION_SIZE	?= ${XCFG_FSIMG_JFFS2_PARTITION_SIZE}

# passing options
FSIMG_OPTIONS	:= JFFS2_ERASE_BLOCK_SIZE=$(JFFS2_ERASE_BLOCK_SIZE)
FSIMG_OPTIONS	+= JFFS2_PARTITION_SIZE=$(JFFS2_PARTITION_SIZE)

FSIMG_TYPE		?= ${XCFG_FSTYPE}
FSIMG_FILE_NAME		?= ${XCFG_FSIMG_FILE_NAME}

FSIMG_WORK_PATH		?= ${XBUILD_WORK_PATH}
FSIMG_OUT_PATH		?= ${XBUILD_OUT_PATH}
FSIMG_ROOT_PATH		?= ${XBUILD_OUT_ROOT_PATH}
FSIMG_ROOT_TMP_CPY_PATH		?= ${XBUILD_OUT_PATH}/tmp-root
FSIMG_ROOT_PATH2	?= ${XBUILD_OUT_RAMDISK_NAND_ROOT_PATH}
FSIMG_MOUNT_PATH	?= ${XBUILD_WORK_MOUNT_PATH}
FSIMG_IMAGE_PATH	?= $(FSIMG_OUT_PATH)/$(FSIMG_FILE_NAME)
FSIMG_DEVTABLE_PATH	?= $(FSIMG_OUT_PATH)/devtable.txt

DATE=`date +%y%m%d-%H%M%S`

###############################################################################
# Action rules

all:	diet create recovery

diet:
	$(Q)rm -rf $(FSIMG_ROOT_TMP_CPY_PATH).org
	$(Q)cp -arf $(FSIMG_ROOT_PATH) $(FSIMG_ROOT_TMP_CPY_PATH).org 
	$(Q)rm -rf $(FSIMG_ROOT_PATH)/usr/include && \
		echo "Clear ${FSIMG_ROOT_PATH}/usr/include"
	$(Q)rm -rf $(FSIMG_ROOT_PATH)/usr/lib/*.a && \
		echo "Clear ${FSIMG_ROOT_PATH}/usr/lib/*.a static library" 
	$(Q)rm -rf $(FSIMG_ROOT_PATH)/usr/share/locale && \
		echo "Clear ${FSIMG_ROOT_PATH}/usr/share/locale" 
	$(Q)rm -rf $(FSIMG_ROOT_PATH)/usr/share/man && \
		echo "Clear ${FSIMG_ROOT_PATH}/usr/share/man" 
	$(Q)rm -rf $(FSIMG_ROOT_PATH)/usr/local/share/info && \
		echo "Clear ${FSIMG_ROOT_PATH}/usr/local/share/info" 
	$(Q)rm -rf $(FSIMG_ROOT_PATH)/usr/local/share/locale && \
		echo "Clear ${FSIMG_ROOT_PATH}/usr/local/share/locale" 
	$(Q)rm -rf $(FSIMG_ROOT_PATH)/usr/local/share/man && \
		echo "Clear $(FSIMG_ROOT_PATH)/usr/local/share/man"

create:		$(dir $(FSIMG_IMAGE_PATH)) \
		$(FSIMG_ROOT_PATH)
	$(Q)rm -rf ${XBUILD_OUT_PATH}/mds-fsimg-$(DATE).tar.gz
	$(Q)tar cvfz ${XBUILD_OUT_PATH}/mds-fsimg-$(DATE).tar.gz -C $(FSIMG_ROOT_PATH)/../ . 
#	$(Q)cd -

mount:		$(FSIMG_MOUNT_PATH) \
		$(FSIMG_IMAGE_PATH)
	$(Q)$(FSIMG_OPTIONS) x.mount.fsimage.sh \
		"$(FSIMG_TYPE)" "$(FSIMG_IMAGE_PATH)" \
		"$(FSIMG_MOUNT_PATH)"

umount:		\
		$(FSIMG_MOUNT_PATH)
	$(Q)$(FSIMG_OPTIONS) x.umount.fsimage.sh \
		"$(FSIMG_TYPE)" "$(FSIMG_IMAGE_PATH)" \
		"$(FSIMG_MOUNT_PATH)"

recovery:
	$(Q)rm -rf $(FSIMG_ROOT_PATH)
	$(Q)mv $(FSIMG_ROOT_TMP_CPY_PATH).org $(FSIMG_ROOT_PATH)

###############################################################################
# Directory rules

$(dir $(FSIMG_IMAGE_PATH)) \
$(FSIMG_MOUNT_PATH):
	$(Q)if [ ! -d "$@" ]; then mkdir -p $@ ; fi

###############################################################################

