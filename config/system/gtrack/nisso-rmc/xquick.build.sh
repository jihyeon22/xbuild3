#!/bin/bash

BUILD_ARG__CORP=nisso
BUILD_ARG__SERVER=nisso-rmc
######################################
# edit plz..
######################################
BUILD_ARG__VER=xx.xx
BUILD_ARG__AUTO_PKG=y
#BUILD_ARG__AUTO_PKG=n
#BUILD_ARG__SUB=alm1
#BUILD_ARG__SUB=alm2

# SUB=nis0 : 기존 프로토콜
# SUB=nis1 : 신규 프로토콜 : 송장추가

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
echo -e "1. 기존 프로토콜"
echo -e "2. 신규 프로토콜 : 송장추가"
echo -e "select data > "

read SELECT_BUILD
case $SELECT_BUILD in
    1)
        BUILD_ARG__SUB="nis0"
    ;;
    2)
        BUILD_ARG__SUB="nis1"
    ;;
    *)
        echo "INVAILD SELECT!!!!!!!!!!!!!!!!!!!!!!! BYE"
        exit
    ;;
esac

RUN_CMD="./xbuild3 $1 CORP=${BUILD_ARG__CORP} SERVER=${BUILD_ARG__SERVER} VER=${BUILD_ARG__VER} SUB=${BUILD_ARG__SUB} AUTO_PKG=${BUILD_ARG__AUTO_PKG} $2"

echo "-----------------------------------------------------------------------------------------"
echo "build run..."
echo "${RUN_CMD}"
echo "-----------------------------------------------------------------------------------------"

${RUN_CMD}
