#!/bin/bash

BUILD_ARG__CORP=alloc
BUILD_ARG__SERVER=alloc3
######################################
# edit plz..
######################################
BUILD_ARG__VER=01.07
BUILD_ARG__AUTO_PKG=y
#BUILD_ARG__AUTO_PKG=n

#BUILD_ARG__SUB=alm2

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
echo -e "1. 중고차 위치관제"
echo -e "2. 중고차 위치관제 + powersave"
echo -e "3. BCM / OBD 연동 카쉐어링"
echo -e "4. DSME Shuttle bus"
echo -e "5. DSME Shuttle bus - Test sever"
echo -e "select data > "

read SELECT_BUILD
case $SELECT_BUILD in
    1)
        BUILD_ARG__SUB="alm2"
        RUN_CMD="./xbuild3 $1 CORP=${BUILD_ARG__CORP} SERVER=${BUILD_ARG__SERVER} VER=${BUILD_ARG__VER} SUB=${BUILD_ARG__SUB} AUTO_PKG=${BUILD_ARG__AUTO_PKG} $2"

    ;;
    2)
        BUILD_ARG__SUB="alm2"
        RUN_CMD="./xbuild3 $1 CORP=${BUILD_ARG__CORP} SERVER=${BUILD_ARG__SERVER} VER=${BUILD_ARG__VER} SUB=${BUILD_ARG__SUB} AUTO_PKG=${BUILD_ARG__AUTO_PKG} NO_USE_NETWORK=y $2"
    ;;
    3)
        BUILD_ARG__SUB="alm1"
        RUN_CMD="./xbuild3 $1 CORP=${BUILD_ARG__CORP} SERVER=${BUILD_ARG__SERVER} VER=${BUILD_ARG__VER} SUB=${BUILD_ARG__SUB} AUTO_PKG=${BUILD_ARG__AUTO_PKG} $2"
    ;;
	4)
        BUILD_ARG__SUB="alc3"
        RUN_CMD="./xbuild3 $1 CORP=${BUILD_ARG__CORP} SERVER=${BUILD_ARG__SERVER} VER=${BUILD_ARG__VER} SUB=${BUILD_ARG__SUB} AUTO_PKG=${BUILD_ARG__AUTO_PKG} $2"
    ;;
	5)
        BUILD_ARG__SUB="alc4"
        RUN_CMD="./xbuild3 $1 CORP=${BUILD_ARG__CORP} SERVER=${BUILD_ARG__SERVER} VER=${BUILD_ARG__VER} SUB=${BUILD_ARG__SUB} AUTO_PKG=${BUILD_ARG__AUTO_PKG} $2"
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
