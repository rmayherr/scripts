#!/usr/bin/env bash

BLUE="\e[44m"
RED="\e[101m"
GREEN="\e[42m"

function first {
    echo ""
    echo -e $RED'Printing arguments in a string by using $*'
    echo -e $*
    echo -e 'Printing arguments by using $* and shift'
    for i in $*;do
	echo -e $*
	shift
    done
}

function second {
    echo ""
    echo -e $GREEN'Printing arguments in a string by using $*'
    echo -e $@
    echo -e 'Printing arguments by using $@ and shift'
    for i in $@;do
        echo -e $1
        shift
    done
}

if [[ $# == 0 ]];then
    echo -e "You did not give any arguments.Bye."
    exit 1
else
    echo ""
    echo -e $BLUE"Number of arguments:"$#
    first $*
    second $@
    echo -e "\e[49m"
    exit 0
fi
