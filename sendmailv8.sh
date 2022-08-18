#!/usr/bin/env bash

WBODY="$HOME/linux/newestv8.txt"
#mailx -r "rmayherr@hu.ibm.com" -s "WebSphere Application Server V8 fixpacks" -S "relay.uk.ibm.com:25" Hungarian.Mainframe.WAS.Team@hu.ibm.com < $WBODY
echo " " >> $WBODY
echo "Sent by Roland Mayherr automated script" >> $WBODY
mailx -r "rmayherr@hu.ibm.com" -s "WebSphere Application Server V8 fixpacks" -S "relay.uk.ibm.com:25" rmayherr@hu.ibm.com < $WBODY 2> /dev/null


