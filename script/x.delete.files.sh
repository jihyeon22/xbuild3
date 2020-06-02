#!/bin/bash

source "${XBUILD_SCRIPT_PATH}/xbuild.env"
source "${XBUILD_SCRIPT_PATH}/xbuild.func"

############################################################################### 
# Functions and Variables
#

script_usage ()
{
    xmsg "BLANK"
    xmsg "USAGE" "Usage: ${0} <root_path> <delfiles_path>"
}

script_delete_target ()
{
    local rootpath="${1}"
    local delpath="${2}"

    xmsg "STEP" "$(basename ${0}): Delete ${delpath} ..."
    if [ ! -e ${rootpath}${delpath} ]; then
        xmsg "SKIP" "Not exists!"
    else
        xrun fakeroot rm -f ${rootpath}${delpath}
        xmsg "SUCCESS" "Completed!"
    fi

    return
}

############################################################################### 
# Arguments
#

rootpath="${1}"
delfilespath="${2}"
if [ ! -d "${rootpath}" ]; then
    xmsg "ERROR" "Error: Not exists root directory!"
    xrun script_usage "${@}"
    exit 1
fi
if [ ! -f "${delfilespath}" ]; then
    xmsg "ERROR" "Error: Not exists delete.files.txt!"
    xrun script_usage "${@}"
    exit 1
fi

############################################################################### 
# Main
#

xmsg "STEP" "$(basename ${0}): Delete files in RootFS ..."
delpathlist=( `cat "${delfilespath}"` )
if [ "${#delpath[*]}" -eq "0" ]; then
    xmsg "SKIP"    "No file to delete!"
    exit 0
else
    xmsg "SUCCESS" "Start!"
    for delpath in ${delpathlist[*]} ; do
        xrun script_delete_target "${rootpath}" "${delpath}"
    done
    exit 0
fi

