#!/bin/bash

BUILD_ARG__CORP=asn
BUILD_ARG__SERVER=asn
######################################
# edit plz..
######################################
BUILD_ARG__VER=xx.yy
BUILD_ARG__AUTO_PKG=y


###########################################
# using help
# 1. build system : ./quick.build.sh system
# 2. clean system : ./quick.build.sh system clean
# 3. build gtrack3 : ./quick.build.sh gtrack3
# 4. clean gtrack3 : ./quick.build.sh gtrack3 clean
###########################################
# ./xbuild3 gtrack3 SERVER=asn CORP=asn VER=01.05 AUTO_PKG=y 
RUN_CMD="./xbuild3 $1 CORP=${BUILD_ARG__CORP} SERVER=${BUILD_ARG__SERVER} VER=${BUILD_ARG__VER} AUTO_PKG=${BUILD_ARG__AUTO_PKG} $2"

echo "-----------------------------------------------------------------------------------------"
echo "build run..."
echo "${RUN_CMD}"
echo "-----------------------------------------------------------------------------------------"

${RUN_CMD}