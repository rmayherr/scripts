#!/usr/bin/env bash


A=""
#if [[ $# == 0 ]];then
#    echo "You did not give any arguments.Bye."
#    exit 1
#else
#    for i in $@;do
#	A=$A$i","
#        shift
#    done
#    echo ${A:0:${#A}-1}
#    exit 0
#fi

if [[ $# == 0 ]];then
    echo "You did not give any arguments.Bye."
    exit 1
else
    echo $* | cut -d " " -f 1-${#} --output-delimiter=','
    exit 0
fi

