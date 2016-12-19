#!/bin/bash

source "${XBUILD_SCRIPT_PATH}/xbuild.env"
source "${XBUILD_SCRIPT_PATH}/xbuild.func"

############################################################################### 
# Functions and Variables
#

script_usage ()
{
    xmsg "BLANK"
    xmsg "USAGE" "Usage: ${0} <check_str>"
}

installation_guide ()
{
    xmsg "BLANK"
    xmsg "ERROR" "Error: You are not installed yet! you can install following command"
	xmsg "USAGE" " ---------------------------------- gcc 3.4.4. ----------------------------------"
    xmsg "USAGE" "       wget http://src-server/downloads/tools/gcc-3.4.4-glibc-2.3.5.tar.bz2"
    xmsg "USAGE" "       sudo mkdir -p /opt/nicta"
    xmsg "USAGE" "       sudo tar vxjf gcc-3.4.4-glibc-2.3.5.tar.bz2 -C /opt/nicta"
    xmsg "USAGE" "       rm -f gcc-3.4.4-glibc-2.3.5.tar.bz2"
	xmsg "USAGE" " ---------------------------------- gcc 4.2.4 ----------------------------------"
    xmsg "USAGE" "       wget http://src-server/downloads/tools/gcc-4.2.4-glibc-2.7.tar.bz2"
    xmsg "USAGE" "       sudo mkdir -p /opt/nicta"
    xmsg "USAGE" "       sudo tar vxjf gcc-4.2.4-glibc-2.7.tar.bz2 -C /opt/nicta"
    xmsg "USAGE" "       rm -f gcc-4.2.4-glibc-2.7.tar.bz2"
}

############################################################################### 
# Arguments
#

crosscompiler="${1}"
checkstr="${2}"
if [ -z "${checkstr}" ]; then
    xmsg "ERROR" "Error: Not selected checking string!"
    xrun script_usage "${@}"
    exit 1
fi

############################################################################### 
# Main
#

teststr=`${crosscompiler} --version 2>&1 | grep "${checkstr}"`

xmsg "FAILURE" "#1 ${teststr}"
xmsg "FAILURE" "#2 ${crosscompiler}"
xmsg "FAILURE" "#3 ${checkstr}"


xmsg "STEP" "$(basename ${0}): Check \"${checkstr}\" ..."
if [ -z "${teststr}" ]; then
    xmsg "FAILURE" "Not matched!!!"
    xrun installation_guide
    exit 1
else
    xmsg "SUCCESS" "${teststr}"
    exit 0
fi

