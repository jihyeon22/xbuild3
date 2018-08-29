#!/bin/bash

BUILD_ARG__CORP=lila
BUILD_ARG__SERVER=lila
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
echo -e "1. DTG + ADAS연동"
#echo -e "2. 기존 프로토콜 + gps 정보매번저장"
echo -e "select data > "

read SELECT_BUILD
case $SELECT_BUILD in
    1)
        BUILD_ARG__SERVER=lila-dtg
        RUN_CMD="./xbuild3 $1 CORP=${BUILD_ARG__CORP} SERVER=${BUILD_ARG__SERVER} VER=${BUILD_ARG__VER} DTG_SERVER=gtrack_tool DTG_MODEL=choyoung AUTO_PKG=${BUILD_ARG__AUTO_PKG} $2"
    ;;
    2)
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
