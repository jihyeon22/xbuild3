#!/bin/bash

source "${XBUILD_SCRIPT_PATH}/xbuild.env"
source "${XBUILD_SCRIPT_PATH}/xbuild.func"

############################################################################### 
# Functions and Variables
#

script_usage ()
{
    xmsg "BLANK"
    xmsg "USAGE" "Usage: ${0} <src_dir> <dst_dir> <src_name> <dst_name>"
}

############################################################################### 
# Arguments
#

srcpath="${1}"
dstpath="${2}"
srcname="${3}"
dstname="${4}"
if [ -z "${srcpath}" ]; then
    xmsg "ERROR" "Error: Not selected source directory!"
    xrun script_usage "${@}"
    exit 1
fi
if [ -z "${dstpath}" ]; then
    xmsg "ERROR" "Error: Not selected destination directory!"
    xrun script_usage "${@}"
    exit 1
fi
if [ -z "${srcname}" ]; then
    xmsg "ERROR" "Error: Not selected source file name!"
    xrun script_usage "${@}"
    exit 1
fi
if [ -z "${dstname}" ]; then
    xmsg "ERROR" "Error: Not selected destination file name!"
    xrun script_usage "${@}"
    exit 1
fi

############################################################################### 
# Main
#

xmsg "STEP" "$(basename ${0}): ${srcname} -> ${dstname} ... "
if [ -e "${dstpath}/${dstname}" ]; then
    xmsg "SKIP" "Already inserted. Skip!"
    exit 0
else
    xmsg "SUCCESS" "Inserting!"
    xrun cp -v ${srcpath}/${srcname} ${dstpath}/${dstname}
    exit 0
fi

