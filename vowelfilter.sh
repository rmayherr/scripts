#!/usr/bin/env bash


function Read() {
    while true
	do
	echo -n "Give me some input or Press [Enter] to exit: "
	read var
	if [[ $var == "" ]]; then
	    echo "It's your decision. Bye"
	    exit
	else
	    Colorize
	fi
	done
}

function Colorize() {
    echo $var | grep --color [aeou]
}

Read
