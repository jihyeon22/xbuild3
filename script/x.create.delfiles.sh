#!/bin/bash

source "${XBUILD_SCRIPT_PATH}/xbuild.env"
source "${XBUILD_SCRIPT_PATH}/xbuild.func"

############################################################################### 
# Functions and Variables
#

script_usage ()
{
    xmsg "BLANK"
    xmsg "USAGE" "Usage: ${0} <work_path> <delfiles_path>"
}

script_collect_delfiles ()
{
    local path="${1}"
    local txtlist=( `find ${path} -name "delete.files.txt"` )

    for txt in ${txtlist[*]} ; do
        echo "${txt}"
    done
}

############################################################################### 
# Arguments
#

workpath="${1}"
outputpath="${2}"
if [ ! -d "${workpath}" ]; then
    xmsg "ERROR" "Error: Not exists work directory!"
    xrun script_usage "${@}"
    exit 1
fi
if [ ! -d "$(dirname ${outputpath})" ]; then
    xmsg "ERROR" "Error: Not exists output directory!"
    xrun script_usage "${@}"
    exit 1
fi

############################################################################### 
# Main
#

xmsg "STEP" "$(basename ${0}): Collect delete files ..."
delfileslist=( `script_collect_delfiles "${workpath}"` )
xmsg "SUCCESS" "Completed!"

xmsg "STEP" "$(basename ${0}): Create delete.files.txt ..."
if [ "${#delfileslist[*]}" -eq "0" ]; then
    xmsg "SKIP"    "No file to create!"
    exit 0
else
    xmsg "SUCCESS" "Start!"
    xrun rm -f "${outputpath}"
    for delpath in ${delfileslist[*]} ; do
        xrun cat "${delpath}" >> "${outputpath}"
    done
    exit 0
fi

