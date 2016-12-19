#!/bin/bash

source "${XBUILD_SCRIPT_PATH}/xbuild.env"
source "${XBUILD_SCRIPT_PATH}/xbuild.func"

############################################################################### 
# Functions and Variables
#

script_usage ()
{
    xmsg "BLANK"
    xmsg "USAGE" "Usage: ${0} <fs_type> <img_path> <mount_path>"
}

source "${XBUILD_SCRIPT_PATH}/xbuild.fsimage.func"

############################################################################### 
# Arguments
#

fstype="${1}"
imgpath="${2}"
mntpath="${3}"
if [ -z "${fstype}" ]; then
    xmsg "ERROR" "Error: Not selected filesystem type!"
    xrun script_usage "${@}"
    exit 1
fi
if [ -z "${imgpath}" ]; then
    xmsg "ERROR" "Error: Not selected image path!"
    xrun script_usage "${@}"
    exit 1
fi
if [ ! -d "${mntpath}" ]; then
    xmsg "ERROR" "Error: Not exists filesystem's mount directory!"
    xrun script_usage "${@}"
    exit 1
fi

############################################################################### 
# Main
#

xmsg "STEP" "$(basename ${0}): ${rootpath} ... "
case "${fstype}" in
    "ext2" )
        xmsg "SUCCESS" "${fstype}"
        xrun xbuild_fsimage_umount_ext2img "${imgpath}" "${mntpath}"
        exit 0
        ;;
    "jffs2" )
        xmsg "SUCCESS" "${fstype}"
        xrun xbuild_fsimage_umount_jffs2img "${imgpath}" "${mntpath}"
        exit 0
        ;;
    * )
        xmsg "FAILURE" "Not supported filesystem type!"
        exit 1
        ;;
esac

