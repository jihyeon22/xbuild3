#!/bin/bash

source "${XBUILD_SCRIPT_PATH}/xbuild.env"
source "${XBUILD_SCRIPT_PATH}/xbuild.func"

############################################################################### 
# Functions and Variables
#

script_usage ()
{
    xmsg "BLANK"
    xmsg "USAGE" "Usage: ${0} <root_path> <pkg_name ...>"
}

############################################################################### 
# Arguments
#

rootpath="${1}"
shift	# rootpath
pkglist=( "${@}" )

############################################################################### 
# Main
#

if [ "${#pkglist[*]}" -ne "0" ]; then
    if [ ! -d "${rootpath}" ]; then
        echo skeleton package
        exit 1
    fi
    for pkg in ${pkglist[*]} ; do
        if [ ! -f "${rootpath}/usr/lib/pkgconfig/${pkg}.pc" ]; then
            echo ${pkg} package
            exit 1
        fi
    done
fi

echo ok
exit 0

