#!/bin/bash

source "${XBUILD_SCRIPT_PATH}/xbuild.env"
source "${XBUILD_SCRIPT_PATH}/xbuild.func"

############################################################################### 
# Functions and Variables
#

script_usage ()
{
    xmsg "BLANK"
    xmsg "USAGE" "Usage: ${0} <work_path> <devtable_path>"
}

script_collect_devtable ()
{
    local path="${1}"
    local txtlist=( `find ${path} -name "devtable.txt"` )

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
    xmsg "ERROR" "Error: Not exists root directory!"
    xrun script_usage "${@}"
    exit 1
fi

############################################################################### 
# Main
#

xmsg "STEP" "$(basename ${0}): Collect device table ..."
devtablelist=( `script_collect_devtable "${workpath}"` )
xmsg "SUCCESS" "Completed!"

xmsg "STEP" "$(basename ${0}): Create whole device table ..."
if [ "${#devtablelist[*]}" -eq "0" ]; then
    xmsg "SKIP"    "No file to create!"
    exit 0
else
    xmsg "SUCCESS" "Start!"
    xrun rm -f "${outputpath}"
    for devtable in ${devtablelist[*]} ; do
        xrun cat "${devtable}" >> "${outputpath}"
    done
    exit 0
fi

