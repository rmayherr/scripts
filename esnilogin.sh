#!/usr/bin/env bash

#################################################################################################################
# Author: Roland Mayherr rmayherr@hu.ibm.com									#
# ESNI login script.Installation instruction:									#
# 1. Turn execution bit on: 	chmod +x esnilogin.sh								#
# 2. Create your password file using the following command: echo "password=MyEsniPassword" > esnipass		#
# 3. Make password file secure:		chmod 400 esnipass							#
# 4. Modify WPATH variable accordingly. esnipass and esnilogin.sh should be in same directory			#
# 5. Login: ./esnilogin.sh Login										#
# 6. Optional: You can put this script into crontab.This way you will be always online				# 
# 	crontab -e												#
#	put this value:												#
#	*/40 08-16 * * 1,2,3,4,5 /your/script/path/esnilogin.sh							#
#################################################################################################################


WTEMP=$(mktemp)
WPATH="/home/rmayherr/Documents/linux"
WPASSFILE=$WPATH/esnipass

function loginesni {
	curl -s -k -d username=hu73696 -d @$WPASSFILE -d Login=Continue https://9.134.79.20:950/netaccess/loginuser.html > /dev/null
}

function logoutesni {
	curl -s -k -d sid=0 -d logout=Log%20Out%20Now https://9.134.79.20:950/netaccess/loginuser.html > /dev/null
}

function pagerefresh {
	curl -s -k https://9.134.79.20:950/netaccess/loginuser.html > /dev/null
}
function connstatus {
	curl -s -k https://9.134.79.20:950/netaccess/connstatus.html -o $WTEMP
	if [[ $? > 1 ]];then
	    return 6
	else
	    cat ${WTEMP} | grep -o "You are not logged in" > /dev/null
	fi
}
case "$1" in
    Login)
	pagerefresh
	connstatus
	case "$?" in
	    0)
		loginesni
	    ;;
	    1)
		echo "You are already logged in."
	    ;;
	    *)
		echo "Something went wrong.You may be not connected to IBM intranet or don't use vpn."
	    ;;
	esac
	echo "Done."
	echo "You can check your status with the following command: $0 Status"
    ;;
    Logout)
	logoutesni
    ;;
    Status)
	connstatus
	case "$?" in
	    0)
		echo "You are not logged in."
	    ;;
	    1)
		echo "You are logged in."
	    ;;
	    6)
		echo "Something went wrong.You may be not connected to IBM intranet or don't use vpn."
	    ;;
	esac
    ;;
    *)
	echo "Invalid argument.Usage: $0 Login|Logout|Status"
    ;;
esac
rm ${WTEMP}
