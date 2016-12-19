#!/bin/bash

source "${XBUILD_SCRIPT_PATH}/xbuild.env"
source "${XBUILD_SCRIPT_PATH}/xbuild.func"

############################################################################### 
# Functions and Variables
#

script_usage ()
{
    xmsg "BLANK"
    xmsg "USAGE" "Usage: ${0} <src_path> <dst_path> <file_name>"
}

############################################################################### 
# Arguments
#

srcpath="${1}"
dstpath="${2}"
filename="${3}"
if [ -z "${srcpath}" ]; then
    xmsg "ERROR" "Error: Not selected source repository path!"
    xrun script_usage "${@}"
    exit 1
fi
if [ -z "${dstpath}" ]; then
    xmsg "ERROR" "Error: Not selected destination directory path!"
    xrun script_usage "${@}"
    exit 1
fi
if [ -z "${dstpath}" ]; then
    xmsg "ERROR" "Error: Not selected file name!"
    xrun script_usage "${@}"
    exit 1
fi

############################################################################### 
# Main
#

xmsg "STEP" "$(basename ${0}): ${srcpath}/${filename} ... "
if [ -e "${dstpath}/${filename}" ]; then
    xmsg "SKIP" "Already exists. Skip!"
    exit 0
else
    xmsg "SUCCESS" "Downloading!"
    if [ "${srcpath:0:7}" == "http://" ]; then
        xrun wget "${srcpath}/${filename}" -P "${dstpath}"
        if [ "${?}" -ne "0" ]; then xrun rm -f "${dstpath}/${filename}" ; fi
        exit 0
    elif [ "${srcpath:0:6}" == "ftp://" ]; then
        xrun wget "${srcpath}/${filename}" -P "${dstpath}"
        if [ "${?}" -ne "0" ]; then xrun rm -f "${dstpath}/${filename}" ; fi
        exit 0
    elif [ "${srcpath:0:6}" == "git://" ]; then
        xrun git clone "${srcpath}" "${dstpath}"
        exit 0
    else
        xmsg "ERROR" "$(basename ${0}): Error: Unknown transfer protocol!"
        exit 1
    fi
fi

