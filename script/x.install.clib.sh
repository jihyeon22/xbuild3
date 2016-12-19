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

script_get_rootrelpath ()
{
    local rootpath="${1}"
    local path="${2}"

    echo "${path##${rootpath}/}"
}

script_get_libpath ()
{
    local libfile="${1}"

    ${toolprefix}gcc --print-file-name="${libfile}"
}

script_get_elflist ()
{
    local path="${1}"

    find ${path} -executable -exec file {} \; | grep "ELF" \
	| grep "dynamically linked" | awk '{print $1}' | sed "s,:,,"
}

script_get_neededlist ()
{
    local path="${1}"

    ${toolprefix}readelf -d ${path} 2>/dev/null | grep "NEEDED" \
	| awk '{print $5}' | sed -e "s,\[,," -e "s,\],,"
}

script_insert_targetlist ()
{
    local lib="${1}"
    local exist="false"

    for target in ${targetlist[*]} ; do
        if [ "${target}" == "${lib}" ]; then
            local exist="true"
            break
        fi
    done

    if [ "${exist}" == "false" ]; then
        targetlist=( ${targetlist[*]} ${lib} )
    fi
}

script_collect_targetlist ()
{
    local path="${1}"
    local neededlist=( `script_get_neededlist "${path}"` )

    if [ "${#neededlist[*]}" -eq "0" ]; then
        return
    else
        for needed in ${neededlist[*]} ; do
            local libpath=`script_get_libpath ${needed}`
            xrun script_collect_targetlist "${libpath}"
        done
        for needed in ${neededlist[*]} ; do
            xrun script_insert_targetlist "${needed}"
        done
        xdbgmsg "${path}: ${neededlist[*]}"
    fi
}

script_install_lib ()
{
    local lib="${1}"
    local dstpath="${2}"
    local libpath=`script_get_libpath "${lib}"`

    xmsg "STEP" "$(basename ${0}): Install ${lib} ..."
    if [ "${libpath}" == "${lib}" ]; then
        xmsg "SKIP" "Not found! Skipping ..."
        return
    elif [ -f "${dstpath}/${lib}" ]; then
        xmsg "SKIP" "Already exists! Skipping ..."
        return
    fi

    if [ -L "${libpath}" ]; then
        local libdir=`dirname ${libpath}`
        local orglibpath=`readlink ${libpath}`
        xmsg "SUCCESS" "Completed!"
        xrun fakeroot ln -vfs "${orglibpath}" "${dstpath}/${lib}"
        xrun script_install_lib "${orglibpath}" "${dstpath}"
        return
    else
        xmsg "SUCCESS" "Completed!"
        xrun fakeroot cp -v "${libpath}" "${dstpath}/${lib}"
    fi
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

if [ ! -x "${toolprefix}gcc" ]; then
    xmsg "ERROR" "Error: Not found ${toolprefix}gcc"
elif [ ! -x "${toolprefix}readelf" ]; then
    xmsg "ERROR" "Error: Not found ${toolprefix}readelf"
fi

############################################################################### 
# Main
#

xmsg "STEP" "$(basename ${0}): Detect needed libraries from binaries ..."
targetlist=( )
elflist=( `script_get_elflist "${rootpath}"` )
for elfpath in ${elflist[*]} ; do
    script_collect_targetlist "${elfpath}"
done
xmsg "SUCCESS" "Detected!"

xmsg "STEP" "$(basename ${0}): Install needed libraries ..."
if [ "${#targetlist[*]}" -eq "0" ]; then
    xmsg "SKIP"    "No needed library!"
    exit 0
else
    xmsg "SUCCESS" "Start!"
    for lib in ${targetlist[*]} ; do
        xrun script_install_lib "${lib}" "${rootpath}/lib"
    done
    exit 0
fi


