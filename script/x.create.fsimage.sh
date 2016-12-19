#!/bin/bash

source "${XBUILD_SCRIPT_PATH}/xbuild.env"
source "${XBUILD_SCRIPT_PATH}/xbuild.func"

############################################################################### 
# Functions and Variables
#

script_usage ()
{
    xmsg "BLANK"
    xmsg "USAGE" "Usage: ${0} <fs_type> <img_path> <root_path> <devtable_path>"
}

source "${XBUILD_SCRIPT_PATH}/xbuild.fsimage.func"

############################################################################### 
# Arguments
#

fstype="${1}"
imgpath="${2}"
rootpath="${3}"
devtable="${4}"
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
if [ ! -d "${rootpath}" ]; then
    xmsg "ERROR" "Error: Not exists filesystem's root directory!"
    xrun script_usage "${@}"
    exit 1
fi
if [ ! -f "${devtable}" ]; then
    xmsg "ERROR" "Error: Not exists device table description file!"
    xrun script_usage "${@}"
    exit 1
fi

############################################################################### 
# Main
#

xmsg "STEP" "$(basename ${0}): ${rootpath} ..."
case "${fstype}" in
    "ext2" )
        xmsg "SUCCESS" "${fstype}"
        inodenum=${EXT2_NUMBER_OF_INODES}
        blksize=${EXT2_BLOCK_SIZE}
        xrun xbuild_fsimage_create_ext2img "${imgpath}" "${rootpath}" "${devtable}" "${inodenum}" "${blksize}"
        exit 0
        ;;
    "jffs2" )
        xmsg "SUCCESS" "${fstype}"
        eraseblksize="${JFFS2_ERASE_BLOCK_SIZE}"
        xrun xbuild_fsimage_create_jffs2img "${imgpath}" "${rootpath}" "${devtable}" "${eraseblksize}"
        xrun xbuild_fsimage_create_recoveryimg "SLC_2048_64_2048_8" "${imgpath}"
        exit 0
        ;;
    * )
        xmsg "FAILURE" "Not supported filesystem type!"
        exit 1
        ;;
esac

