#!/bin/bash

source "${XBUILD_SCRIPT_PATH}/xbuild.env"
source "${XBUILD_SCRIPT_PATH}/xbuild.func"

############################################################################### 
# Functions and Variables
#

script_usage ()
{
    xmsg "BLANK"
    xmsg "USAGE" "Usage: ${0} <tool_prefix> <root_path>"
}

script_get_elflist ()
{
    local path="${1}"

    find ${path} -executable -exec file {} \; \
	| grep "executable" | grep "not stripped" \
	| awk '{print $1}' | sed "s,:,,"
}

script_strip_elf ()
{
    local elfpath="${1}"
    local elfrelpath="${elfpath##${rootpath}/}"

    xmsg "STEP" "$(basename ${0}): Strip ${elfrelpath} ..."
    xrun ${toolprefix}strip ${elfpath}
    xmsg "SUCCESS" "Completed!"

    return
}

############################################################################### 
# Arguments
#

toolprefix="${1}"
rootpath="${2}"
if [ -z "${toolprefix}" ]; then
    xmsg "ERROR" "Error: Not selected toolchain prefix!"
    xrun script_usage "${@}"
    exit 1
fi
if [ ! -d "${rootpath}" ]; then
    xmsg "ERROR" "Error: Not exists root directory!"
    xrun script_usage "${@}"
    exit 1
fi

if [ ! -x "${toolprefix}strip" ]; then
    xmsg "ERROR" "Error: Not found ${toolprefix}strip"
fi

############################################################################### 
# Main
#

xmsg "STEP" "$(basename ${0}): Detect not stripped binaries ..."
targetlist=( )
elflist=( `script_get_elflist "${rootpath}"` )
xmsg "SUCCESS" "Detected!"

xmsg "STEP" "$(basename ${0}): Strip binaries ..."
if [ "${#elflist[*]}" -eq "0" ]; then
    xmsg "SKIP"    "All files are already stripped!"
    exit 0
else
    xmsg "SUCCESS" "Start!"
    for elfpath in ${elflist[*]} ; do
        xrun script_strip_elf "${elfpath}"
    done
    exit 0
fi


