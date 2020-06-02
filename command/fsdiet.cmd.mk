
include ${XBUILD_COMMAND_PATH}/include/common.mk

###############################################################################
# Variables

FSIMG_ROOT_PATH		?= ${XBUILD_OUT_ROOT_PATH}

###############################################################################
# Action rules

all:		diet

diet:
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
		echo "Clear ${FSIMG_ROOT_PATH}/usr/local/share/man" 

###############################################################################

