#!/usr/bin/env bash

function getDate {
    echo `date -d now +%j`
}
function getDateMac {
	echo `date '+%j'`
}
if [ `uname -s` == "Darwin" ]; 
then
	getDateMac
else
	getDate
fi
