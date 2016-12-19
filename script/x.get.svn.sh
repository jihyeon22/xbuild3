#!/bin/bash

source "${XBUILD_SCRIPT_PATH}/xbuild.env"
source "${XBUILD_SCRIPT_PATH}/xbuild.func"

############################################################################### 
# Functions and Variables
#

script_usage ()
{
    xmsg "BLANK"
    xmsg "USAGE" "Usage: ${0} <src_svn_path> <dst_dir_path> <options ...>"
}

############################################################################### 
# Arguments
#

srcpath="${1}"
dstpath="${2}"
shift	# srcpath
shift	# dstpath
options="${@}"
if [ -z "${srcpath}" ]; then
    xmsg "ERROR" "Error: Not selected source svn repository!"
    xrun script_usage "${@}"
    exit 1
fi
if [ -z "${dstpath}" ]; then
    xmsg "ERROR" "Error: Not selected destination directory!"
    xrun script_usage "${@}"
    exit 1
fi

############################################################################### 
# Main
#

xmsg "STEP" "$(basename ${0}): ${srcpath} ... "
if [ -e "${dstpath}" ]; then
    xmsg "SKIP" "Already exists. Skip!"
    exit 0
else
    xmsg "SUCCESS" "Downloading!"
    xrun svn checkout "${srcpath}" "${dstpath}" ${options}
    exit 0
fi

