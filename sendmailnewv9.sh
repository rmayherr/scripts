#!/usr/bin/env bash

WBODY="$HOME/linux/newestv9.txt"
#mailx -r "rmayherr@hu.ibm.com" -s "WebSphere Application Server V9 fixpacks" -S "relay.uk.ibm.com:25" Hungarian.Mainframe.WAS.Team@hu.ibm.com < $WBODY
mailx -r "rmayherr@hu.ibm.com" -s "WebSphere Application Server V9 newest fixpack is available" -S "relay.uk.ibm.com:25" rmayherr@hu.ibm.com < $WBODY

