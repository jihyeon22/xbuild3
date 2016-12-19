#!/bin/bash

source "${XBUILD_TOOL_PATH}/gitinfo.env"

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

srcpath="${1}"
dstpath="${2}"
checkout="${3}"

if [ -z "${srcpath}" ]; then
    xmsg "ERROR" "Error: Not selected source git repository!"
    xrun script_usage "${@}"
    exit 1
fi
if [ -z "${dstpath}" ]; then
    xmsg "ERROR" "Error: Not selected destination directory!"
    xrun script_usage "${@}"
    exit 1
fi

############################################################################### 
# Main
#
echo " - script info : sre path ==> ${srcpath}"
echo " - script info : dst path ==> ${dstpath}"
echo " - script info : checkout info ==> ${checkout}"
echo " - script info : git pass ==> ${XBUILD_GIT_PASSWD}"

xmsg "STEP" "$(basename ${0}): ${srcpath} ... "
if [ -e "${dstpath}" ]; then
    xmsg "SKIP" "Already exists. Skip!"
else

if [ ! -z "${XBUILD_GIT_PASSWD}" ]; then
    xmsg "SUCCESS" "Downloading!"
	expect <<END
	set timeout 500
	spawn git clone "${srcpath}" "${dstpath}" 
	expect "password:"
	send "${XBUILD_GIT_PASSWD}\r"
	expect eof 
END
else
	git clone -q "${srcpath}" "${dstpath}"	
fi

fi

if [ ! -z "${checkout}" ]; then
    xmsg "STEP" "$(basename ${0}): move to commit '${checkout}' ... "
    xmsg "SUCCESS" "Checking out!"
    xrun pushd "${dstpath}"

if [ ! -z "${XBUILD_GIT_PASSWD}" ]; then
	expect <<END
	spawn git checkout "${checkout}"
	expect "password:"
	send "${XBUILD_GIT_PASSWD}\r"
	expect eof
END
else
	git checkout "${checkout}"
fi

	xrun popd
fi

if [ -z "${checkout}" ]; then
	xmsg "NOTICE" "Tag info is nothing..."
	xmsg "ERROR" ""
	xmsg "SUCCESS" "checkout success bye bye.."
	xmsg "ERROR" ""
	exit 0
fi

	CUR_VERSION_NUM=`echo ${checkout} | sed -e 's/-/\n/g' | tail -n 1`
	CUR_MODEL_NAME=`echo ${checkout} | sed -e 's/'${CUR_VERSION_NUM}'//g'`
	CUR_VERION_INFO=${checkout}


	xmsg "NOTICE" "check remote tag version info..."
if [ ! -z "${XBUILD_GIT_PASSWD}" ]; then
	REMOTE_GIT_INFO=`expect <<END
	spawn git ls-remote ${srcpath}
	expect "password:"
	send "${XBUILD_GIT_PASSWD}\r"
	expect eof
END`
else
	REMOTE_GIT_INFO=`git ls-remote ${srcpath}`
fi
	if [ -z "${CUR_MODEL_NAME}" ]; then
		REMOTE_LASTEST_VERSION_INFO=`echo "${REMOTE_GIT_INFO}" | tail -n 1 | awk '{print $2}' | grep tags | sed -e 's/refs\/tags\///g' `
		REMOTE_LASTEST_VERSION_NUM=`echo ${REMOTE_LASTEST_VERSION_INFO} | sed -e 's/-/\n/g' | tail -n 1`
	else
		echo ${REMOTE_TAG_INFO}
		REMOTE_LASTEST_VERSION_INFO=`echo "${REMOTE_GIT_INFO}" | grep ${CUR_MODEL_NAME} |  tail -n 1 | awk '{print $2}' | grep tags | sed -e 's/refs\/tags\///g' `
		REMOTE_LASTEST_VERSION_NUM=`echo ${REMOTE_LASTEST_VERSION_INFO} | sed -e 's/-/\n/g' | tail -n 1`
	fi

	REMOTE_LASTEST_VERSION_INFO_TMP=`echo ${REMOTE_LASTEST_VERSION_INFO}|tr -d '\r'`

	if [ "${CUR_VERION_INFO}" = "${REMOTE_LASTEST_VERSION_INFO_TMP}" ]; then
		xmsg "SUCCESS" "$CUR_VERION_INFO is lastest version"
	else
		xmsg "ERROR" "current version >>>    ${CUR_VERION_INFO}"
		xmsg "ERROR" "lastest version >>>    ${REMOTE_LASTEST_VERSION_INFO}"
		xmsg "ERROR" ""
	
		xmsg "ERROR" "warnning!!! version is not lastest verison : press any key for check tag info..."
		read input_key
		xmsg "NOTICE" "git repogitory tag info -------------------------------------"
		echo "${REMOTE_GIT_INFO}"
		xmsg "NOTICE" "-------------------------------------------------------------------"

		xmsg "ERROR" ""
		xmsg "ERROR" "warnning!!! continue.. press any key"
		read input_key
	fi

	xmsg "ERROR" ""
	xmsg "SUCCESS" "checkout success bye bye.."
	xmsg "ERROR" ""
exit 0

