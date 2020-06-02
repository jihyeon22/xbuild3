#!/bin/bash

BUILD_ARG__CORP=skyan
BUILD_ARG__SERVER=skyan
######################################
# edit plz..
######################################
BUILD_ARG__VER=xx.xx
BUILD_ARG__AUTO_PKG=y
#BUILD_ARG__AUTO_PKG=n
#BUILD_ARG__SUB=alm1
#BUILD_ARG__SUB=alm2

###########################################
# using help
# 1. build system : ./quick.build.sh system
# 2. clean system : ./quick.build.sh system clean
# 3. build gtrack3 : ./quick.build.sh gtrack3
# 4. clean gtrack3 : ./quick.build.sh gtrack3 clean
###########################################

RUN_CMD="./xbuild3 $1 CORP=${BUILD_ARG__CORP} SERVER=${BUILD_ARG__SERVER} VER=${BUILD_ARG__VER} AUTO_PKG=${BUILD_ARG__AUTO_PKG} $2"

echo "-----------------------------------------------------------------------------------------"
echo "build run..."
echo "${RUN_CMD}"
echo "-----------------------------------------------------------------------------------------"

${RUN_CMD}