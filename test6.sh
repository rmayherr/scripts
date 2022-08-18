#!/usr/bin/env bash

A=("127" "0" "0" "1")
for ((i=0;i<5;i++))
do
    B+=`echo 'obase=2;'${A[$i]}'' | bc`
    case $i in
	0|1|2)B+=".";;
    esac
done
echo $B