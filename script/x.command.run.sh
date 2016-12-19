#!/bin/bash

source "${XBUILD_SCRIPT_PATH}/xbuild.env"
source "${XBUILD_SCRIPT_PATH}/xbuild.func"

xrun xbuild_command_run "${@}"

exit ${?}
