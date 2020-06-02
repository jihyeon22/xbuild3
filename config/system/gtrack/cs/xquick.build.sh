#!/bin/bash

BUILD_ARG__CORP=cs
BUILD_ARG__SERVER=cs
######################################
# edit plz..
######################################
BUILD_ARG__VER=xx.yy
BUILD_ARG__AUTO_PKG=y
#BUILD_ARG__AUTO_PKG=n

###########################################
# using help
# 1. build system : ./quick.build.sh system
# 2. clean system : ./quick.build.sh system clean
# 3. build gtrack3 : ./quick.build.sh gtrack3
# 4. clean gtrack3 : ./quick.build.sh gtrack3 clean
###########################################

echo -e "--------------------------------------------------"
echo -e "BUILD TARGET"
echo -e "--------------------------------------------------"
echo -e "1. 기본 프로토콜"
echo -e "2. 동작센서연동"
echo -e "select data > "

read SELECT_BUILD
case $SELECT_BUILD in
    1)
        RUN_CMD="./xbuild3 $1 CORP=${BUILD_ARG__CORP} SERVER=${BUILD_ARG__SERVER} VER=${BUILD_ARG__VER} AUTO_PKG=${BUILD_ARG__AUTO_PKG} $2"
    ;;
    2)
        BUILD_ARG__SUB="cs1"
        RUN_CMD="./xbuild3 $1 CORP=${BUILD_ARG__CORP} SERVER=${BUILD_ARG__SERVER} VER=${BUILD_ARG__VER} SUB=${BUILD_ARG__SUB}  AUTO_PKG=${BUILD_ARG__AUTO_PKG} $2"
    ;;
    *)
        echo "INVAILD SELECT!!!!!!!!!!!!!!!!!!!!!!! BYE"
        exit
    ;;
esac



echo "-----------------------------------------------------------------------------------------"
echo "build run..."
echo "${RUN_CMD}"
echo "-----------------------------------------------------------------------------------------"

${RUN_CMD}