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
    xmsg "USAGE" "       wget http://src-server/downloads/tools/RVDS22_Installed.tar.bz2"
    xmsg "USAGE" "       sudo mkdir -p /opt/ARM"
    xmsg "USAGE" "       sudo tar vxjf RVDS22_Installed.tar.bz2 -C /opt/ARM"
    xmsg "USAGE" "       rm -f RVDS22_Installed.tar.bz2"
}

installation_guide_lic ()
{
    xmsg "BLANK"
    xmsg "ERROR" "Error: You need to set ARMLMD_LICENSE_FILE environment! Please open and edit tool.env file"
    xmsg "USAGE" "       vim ./env/tool.env"
}

############################################################################### 
# Arguments
#

checkstr="${1}"
if [ -z "${checkstr}" ]; then
    xmsg "ERROR" "Error: Not selected checking string!"
    xrun script_usage "${@}"
    exit 1
fi

############################################################################### 
# Main
#

teststr=`armcc 2>&1 | grep ${checkstr}`

xmsg "STEP" "$(basename ${0}): Check \"${checkstr}\" ..."
if [ -z "${teststr}" ]; then
    xmsg "FAILURE" "Not matched!"
    xrun installation_guide
    exit 1
else
    xmsg "SUCCESS" "${teststr}"
fi

teststr=`armcc 2>&1 | grep "Software supplied by: ARM Limited"`

xmsg "STEP" "$(basename ${0}): Check ARM license ..."
if [ -z "${teststr}" ]; then
    xmsg "FAILURE" "Not set ARM license!"
    xrun installation_guide_lic
    exit 1
else
    xmsg "SUCCESS" "${teststr}"
    exit 0
fi

