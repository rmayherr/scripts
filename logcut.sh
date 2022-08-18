#!/usr/bin/env bash

LOG="/opt/WAS855/AppServer/profiles/c1as1/logs/server1/SystemOut.log"

for i in `cat $LOG`
do
    ${i:50:5}
    if [[ ${i:50:1} == E ]];then
	echo $i
    fi
done