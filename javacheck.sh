#!/usr/bin/env bash

IFS=$'\n'
ALTDIR="/etc/alternatives"
TMPF1="$(mktemp)"
function CheckLink() {
    exec `./$ALTDIR/java > /dev/null 2>1` 
    if [ "$?" -eq "0" ];then
	echo "java link is correct"
	return 0
    else
	echo "java is not available"
	return 1
    fi
}

function CheckVersion() {
    exec `cd $ALTDIR; ./java -version 2> ${TMPF1}`
    if [ $? -eq 0 ];then
	JAVA_VERSION=`head -n1 ${TMPF1} | cut -d'"' -f2`
	exec `rm ${TMPF1}`
    	echo "Current java version is " $JAVA_VERSION
	return 0
    else
	echo "Error occurred during checking the current java version!"
	return 1
    fi
}

function GetLatest() {
    local RESULT=`rpm -qa | grep "java-[0-9].[0-9].[0-9]-\(openjdk\|oracle\|ibm\)-[0-9]" | sort -r | head -n1`
    echo "Latest java package is " $RESULT
    JAVA_PATH=`locate ${RESULT} | head -n1`
    echo "The latest JAVA_PATH is "$JAVA_PATH
    if [ $? -eq 0 ];then
	return 0
    else
	echo "Error occurred during getting the latest package!"
        return 1
    fi
}

function SetJavaLink() {
    exec `ln -sf $JAVA_PATH/bin/java /etc/alternatives/java`
    if [ $? -eq 0 ];then
	echo "Setting java symlink ln -sf " $JAVA_PATH"/bin/java /etc/alternatives/java"
	return 0
    else
	echo "Error occurred during setting symlink!"
        return 1
    fi    

}

if [ `id | cut -d "(" -f1 | cut -d "=" -f2` == "0" ];then
    CheckLink
    if [ CheckLink ]; then
	CheckVersion
	if [ CheckVersion ]; then
	    GetLatest
	    if [ GetLatest ]; then
		SetJavaLink
		if [ SetJavaLink ]; then
		    CheckVersion
		fi
	    fi
	fi
    fi
else
    echo "You must run this script by root user!"
fi
