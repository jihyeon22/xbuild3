#!/bin/bash

source "${XBUILD_SCRIPT_PATH}/xbuild.env"
source "${XBUILD_SCRIPT_PATH}/xbuild.func"

############################################################################### 
# Functions and Variables
#

script_usage ()
{
    xmsg "BLANK"
    xmsg "USAGE" "Usage: ${0} <src_path> <dst_path>"
}

############################################################################### 
# Arguments
#

srcpath="${1}"
dstpath="${2}"
if [ ! -f "${srcpath}" ]; then
    xmsg "ERROR" "Error: Not exists source file!"
    xrun script_usage "${@}"
    exit 1
fi
if [ ! -d "$(dirname ${dstpath})" ]; then
    xmsg "ERROR" "Error: Not exists destination directory path!"
    xrun script_usage "${@}"
    exit 1
fi

############################################################################### 
# Main
#

filename=$(basename ${srcpath})
format=`file ${srcpath} | awk '{print $2}'`

xmsg "STEP" "$(basename ${0}): ${filename} ... "
if [ -e "${dstpath}" ]; then
    xmsg "SKIP" "Already exists. Skip!"
    exit 0
else
    xmsg "SUCCESS" "Uncompressing!"
    case "${format}" in
        "bzip2" )  opt="j" ;;
        "gzip"  )  opt="z" ;;
        "tar"   )  opt=""  ;;
        *       )
            xmsg "ERROR" "$(basename ${0}): Error: Unknown compressed file format!"
            exit 1
            ;;
    esac
    xrun tar vx${opt}f "${srcpath}" -C "$(dirname ${dstpath})"
    exit 0
fi

