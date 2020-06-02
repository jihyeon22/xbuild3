#!/bin/bash

source "${XBUILD_SCRIPT_PATH}/xbuild.env"
source "${XBUILD_SCRIPT_PATH}/xbuild.func"

############################################################################### 
# Functions and Variables
#

script_usage ()
{
    xmsg "BLANK"
    xmsg "USAGE" "Usage: ${0} <root_path> <sysfile_path ...>"
}

############################################################################### 
# Arguments
#

rootpath="${1}"
shift	# rootpath
sysfilelist=( "${@}" )

############################################################################### 
# Main
#

if [ "${#sysfilelist[*]}" -ne "0" ]; then
    if [ ! -d "${rootpath}" ]; then
        echo skeleton package
        exit 1
    fi
    for sysfile in ${sysfilelist[*]} ; do
        if [ ! -f "${rootpath}/${sysfile}" ]; then
            echo ${sysfile}
            exit 1
        fi
    done
fi

echo ok
exit 0

