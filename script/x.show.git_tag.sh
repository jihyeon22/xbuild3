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

repourl="${1}"
checkout="${2}"

if [ "$checkout"="" ];
then
	checkout="tag info is nothing"
fi

############################################################################### 
# Main
#


xmsg "NOTICE" "."
xmsg "NOTICE" "."
xmsg "NOTICE" "."
xmsg "NOTICE" "."
xmsg "NOTICE" "."

xmsg "NOTICE" "=========================================================="
xmsg "SUCCESS" "check repository tag ==> [ ${repourl} ]"
xmsg "BLANK"
xrun git ls-remote -t "${repourl}" | awk '{print $2}' | cut -d '/' -f 3 | cut -d '^' -f 1  | uniq
xmsg "NOTICE" "=========================================================="
xmsg "BLANK"
xmsg "SUCCESS" "your tag info is ==> [ ${checkout} ]"
xmsg "BLANK"
xmsg "NOTICE" "check your tag info... press anykey continue"
xrun read text

xmsg "BLANK"
xmsg "BLANK"

exit 0

