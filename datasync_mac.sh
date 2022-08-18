#!/usr/bin/env bash


function copyData {
    WSRC="/System/Volumes/Data/IBM_Data"
    echo "copying files from" $WSRC " to " $WARG1
    rsync -aur --exclude='.*' --exclude 'VirtualBox'  $WSRC $WARG1
}

case $# in
    1)
	WARG1=$1
	copyData
    ;;
    *)
	echo "Improper parameter. Usage:" $0 "[Target directory]"
    ;;
esac
