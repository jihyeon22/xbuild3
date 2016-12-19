#!/bin/bash

source "${XBUILD_SCRIPT_PATH}/xbuild.env"
source "${XBUILD_SCRIPT_PATH}/xbuild.func"

############################################################################### 
# Functions and Variables
#

script_usage ()
{
    xmsg "BLANK"
    xmsg "USAGE" "Usage: ${0} <src_git_path> <dst_dir_path> [<git_tag_name>]"
}

############################################################################### 
# Arguments
#

dstpath="${1}"
gccver="${2}"

if [ -z "${dstpath}" ]; then
    xmsg "ERROR" "Error: Not selected destination directory!"
    xrun script_usage "${@}"
    exit 1
fi
if [ -z "${gccver}" ]; then
    xmsg "ERROR" "Error: Not selected destination directory!"
    xrun script_usage "${@}"
    exit 1
fi

############################################################################### 
# Main
#
xmsg "STEP" "$(basename ${0}): ${dstpath} find gcc ver >> ${gccver} !"

FILE_LIST=`find ${dstpath} -name *_${gccver}`
CURRENT_DIR=${PWD}
xmsg "STEP" "$(basename ${0}):  ${PWD}"


for file in ${FILE_LIST}
do
	echo "file is ${file}"
	filename=$(basename "$file")
	filepath=$(dirname "$file")
	linkfile=${filename%_${gccver}}
#	echo "link is ${linkfile}"
#	echo "file name is ${filename}"
#	echo "file path is ${filepath}"
	echo "file link target is ${linkfile} to ${filename}"
	cd ${filepath} 
	rm -rf ${linkfile}
	ln -s  ${filename} ${linkfile}
	cd ${CURRENT_DIR}
#ln -s ${file} machines.py
#    cp -rf ${file} ${filename}
#       rm -rf ${file}
done

if [ -e "${dstpath}" ]; then
    xmsg "SKIP" "Already exists. Skip!"
else
    xmsg "SUCCESS" "Downloading!"
    xrun git clone "${srcpath}" "${dstpath}"
fi

if [ ! -z "${checkout}" ]; then
    xmsg "STEP" "$(basename ${0}): move to commit '${checkout}' ... "
    xmsg "SUCCESS" "Checking out!"
    xrun pushd "${dstpath}"
    xrun git checkout "${checkout}"
    xrun popd
fi

exit 0

