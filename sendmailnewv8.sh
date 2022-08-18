#!/usr/bin/env bash

HOME="/IBM_Data"
WBODY="$HOME/linux/newestv8.txt"
#mailx -r "rmayherr@hu.ibm.com" -s "WebSphere Application Server V8 fixpacks" -S "relay.uk.ibm.com:25" Hungarian.Mainframe.WAS.Team@hu.ibm.com < $WBODY
mailx -r "rmayherr@hu.ibm.com" -s "WebSphere Application Server V8 newest fixpack is available" -S "relay.uk.ibm.com:25" rmayherr@hu.ibm.com < $WBODY

