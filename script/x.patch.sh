#!/bin/bash

source "${XBUILD_SCRIPT_PATH}/xbuild.env"
source "${XBUILD_SCRIPT_PATH}/xbuild.func"

############################################################################### 
# Functions and Variables
#

script_usage ()
{
    xmsg "BLANK"
    xmsg "USAGE" "Usage: ${0} <src_dir> <dst_dir> <patch_file ...>"
}

############################################################################### 
# Arguments
#

srcpath="${1}"
dstpath="${2}"
shift	# srcpath
shift	# dstpath
patchlist=( "${@}" )
if [ -z "${srcpath}" ]; then
    xmsg "ERROR" "Error: Not selected source file path!"
    xrun script_usage "${@}"
    exit 1
fi
if [ -z "${dstpath}" ]; then
    xmsg "ERROR" "Error: Not selected destination directory path!"
    xrun script_usage "${@}"
    exit 1
fi

############################################################################### 
# Main
#

xmsg "STEP" "$(basename ${0}): ${dstpath} ... "
if [ -e "${dstpath}/.patch.info" ]; then
    xmsg "SKIP" "Already patched. Skip!"
    exit 0
elif [ "${#patchlist[*]}" -eq "0" ]; then
    xmsg "SKIP" "No patch files. Skip!"
    exit 0
else
    xmsg "SUCCESS" "Patching!"
    xrun rm -vf "${dstpath}/.patch.info"
    for p in ${patchlist[*]} ; do
        xmsg "LOG" "${p}"					| tee -a "${dstpath}/.patch.info"
        xrun patch -d ${dstpath} -p1 < ${srcpath}/${p} 2>&1	| tee -a "${dstpath}/.patch.info"
    done
    exit 0
fi

