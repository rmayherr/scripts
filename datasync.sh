#!/usr/bin/env bash


function copyDocuments {
    WSRC="/home/rmayherr/Documents"
    echo "copying files from" $WSRC " to " $WARG1
    rsync -aur --exclude='.*'  $WSRC $WARG1
}

function copyDesktop {
    WSRC="/home/rmayherr/Desktop"
    echo "copying files from" $WSRC " to " $WARG1
    rsync -aur --exclude='.*'  $WSRC $WARG1
}

function copyDownloads {
    WSRC="/home/rmayherr/Downloads"
    echo "copying files from" $WSRC " to " $WARG1
    rsync -aur --exclude='.*'  $WSRC $WARG1
}

case $# in
    1)
	WARG1=$1
	copyDocuments
	copyDesktop
	copyDownloads
    ;;
    *)
	echo "Improper parameter. Usage:" $0 "[Target directory]"
    ;;
esac