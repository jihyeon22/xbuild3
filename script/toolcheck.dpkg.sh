#!/bin/bash

source "${XBUILD_SCRIPT_PATH}/xbuild.env"
source "${XBUILD_SCRIPT_PATH}/xbuild.func"

###############################################################################
# Functions and Variables
#

script_usage ()
{
    xmsg "BLANK"
    xmsg "USAGE" "Usage: ${0} <package_name>"
}

installation_guide ()
{
    xmsg "BLANK"
    xmsg "ERROR" "Error: You are not installed yet! you can install following command"
    xmsg "USAGE" "       sudo apt-get install ${checkpkg}"
}

###############################################################################
# Arguments
#

checkpkg="${1}"
if [ -z "${checkpkg}" ]; then
    xmsg "ERROR" "Error: Not selected package name!"
    xrun script_usage "${@}"
    exit 1
fi

############################################################################### 
# Main
#

teststr=`dpkg -l ${checkpkg} 2>/dev/null | grep "ii"`
pkgname=`echo ${teststr} | awk '{print $2}'`
pkgver=`echo ${teststr} | awk '{print $3}'`

xmsg "STEP" "$(basename ${0}): Check \"${checkpkg}\" package ..."
if [ -z "${teststr}" ]; then
    xmsg "FAILURE" "Not installed!"
    xrun installation_guide
    exit 1
else
    xmsg "SUCCESS" "${pkgname} ${pkgver}"
    exit 0
fi

