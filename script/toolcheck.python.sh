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
    xmsg "USAGE" "       wget http://src-server/downloads/tools/Python-2.4.6.tgz"
    xmsg "USAGE" "       tar xzf Python-2.4.6.tgz"
    xmsg "USAGE" "       pushd Python-2.4.6"
    xmsg "USAGE" "       ./configure BASECFLAGS=-U_FORTIFY_SOURCE -with-zlib=/usr/include"
    xmsg "USAGE" "       make"
    xmsg "USAGE" "       sudo make install"
    xmsg "USAGE" "       popd"
    xmsg "USAGE" "       sudo rm -rf Python-2.4.6"
    xmsg "USAGE" "       rm -f Python-2.4.6.tgz"
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

teststr=`python -V 2>&1 | grep "${checkstr}"`

xmsg "STEP" "$(basename ${0}): Check \"${checkstr}\" ..."
if [ -z "${teststr}" ]; then
    xmsg "FAILURE" "Not matched!"
    xrun installation_guide
    exit 1
else
    xmsg "SUCCESS" "${teststr}"
    exit 0
fi

