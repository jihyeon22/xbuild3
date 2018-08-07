#!/bin/bash

BUILD_ARG__CORP=cl
BUILD_ARG__SERVER=cl-rfid
######################################
# edit plz..
######################################
BUILD_ARG__VER=xx.yy
BUILD_ARG__AUTO_PKG=y
#BUILD_ARG__AUTO_PKG=n
#BUILD_ARG__SUB=alm1
#BUILD_ARG__SUB=alm2

####################
# kjtec rfid only
####################

# SUB=clr0 : kjtec rfid + 위치관제 => 현대서버
# SUB=clr1 : kjtec rfid + 위치관제 => CL 서버

####################
# kjtec rfid + adas 
####################
# SUB=clra0 : kjtec rfid + 위치관제 + 모본 ADAS => CL 서버
# SUB=clra1 : kjtec rfid + 위치관제 + 모본 ADAS => 현대서버
# SUB=clra9 : kjtec rfid + 위치관제 + 모본 ADAS => 테스트서버

# SUB=clrb0 : kjtec rfid + 위치관제 + 모빌아이 ADAS => CL 서버
# SUB=clrb1 : kjtec rfid + 위치관제 + 모빌아이 ADAS => 현대서버
# SUB=clra9 : kjtec rfid + 위치관제 + 모본 ADAS => 테스트서버

####################
# sup rfid only
####################
# SUB=clrc9 : sup rfid + 위치관제 => 테스트서버

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
echo -e "01. kjtec rfid + MDT => 현대서버"
echo -e "02. kjtec rfid + MDT => CL서버"
echo -e "--------------------------------------------------"
echo -e "11. kjtec rfid + 위치관제 + 모본 ADAS => CL 서버"
echo -e "12. kjtec rfid + 위치관제 + 모본 ADAS => 현대서버"
echo -e "13. kjtec rfid + 위치관제 + 모본 ADAS => 테스트서버"
echo -e "--------------------------------------------------"
echo -e "21. kjtec rfid + 위치관제 + 모빌아이 ADAS => CL 서버"
echo -e "22. kjtec rfid + 위치관제 + 모빌아이 ADAS => 현대서버"
echo -e "23. kjtec rfid + 위치관제 + 모빌아이 ADAS => 테스트서버"
echo -e "--------------------------------------------------"
echo -e "select data > "

read SELECT_BUILD
case $SELECT_BUILD in
    01)
        BUILD_ARG__SUB="clr0"
    ;;
    02)
        BUILD_ARG__SUB="clr1"
    ;;
    11)
        BUILD_ARG__SUB="clra0"
    ;;
    12)
        BUILD_ARG__SUB="clra1"
    ;;
    13)
        BUILD_ARG__SUB="clra9"
    ;;
    21)
        BUILD_ARG__SUB="clrb0"
    ;;
    22)
        BUILD_ARG__SUB="clrb1"
    ;;
    23)
        BUILD_ARG__SUB="clrb9"
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
