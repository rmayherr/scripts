#!/usr/bin/env bash

WBODY="$HOME/linux/resultv9.txt"
#mailx -r "rmayherr@hu.ibm.com" -s "WebSphere Application Server V9 fixpacks" -S "relay.uk.ibm.com:25" Hungarian.Mainframe.WAS.Team@hu.ibm.com < $WBODY
echo " " >> $WBODY
echo "Sent by Roland Mayherr automated script " >> $WBODY
mailx -r "rmayherr@hu.ibm.com" -s "WebSphere Application Server V9 fixpacks" -S "relay.uk.ibm.com:25" rmayherr@hu.ibm.com < $WBODY 2> /dev/null


