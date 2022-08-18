#!/usr/bin/env bash

#Specifiy the base directory, where scripts reside and files will be created.
WORKDIR="$HOME/Documents/linux"
#Declare work files
WFILE="$WORKDIR/wasv9.txt"
WFILE2="$WORKDIR/wtemp.txt"
WRESULT="$WORKDIR/resultv9.txt"
WNEWEST="$WORKDIR/newestv9.txt"
#Declare log file
LOG="$WORKDIR/statusv9.log"

function GetHtml() {
    #Download the appropiate html file from internet and put it into a file with -o option
    #stderr is redirected into stdout.Everything goes into /dev/null
    curl http://www-01.ibm.com/support/docview.wss?uid=swg27004980 -o $WFILE >> /dev/null 2>&1
}

function ProcessHtml() {
    #Get the number of starting point of "Version 9" string
    WROW=`cat ${WFILE} | nl | grep '<b>Version 9.0</b>' | cut -d "<" -f 1`
    #Cut a range of lines from html into a file
    exec `sed -n ''"${WROW}"',/<b>Additional information/p' ${WFILE} > ${WFILE2} `
    #Drop html tags out
    exec `sed -i 's/<[^<]*>//g' ${WFILE2}`
    #Get Fixpacknumbers and their date from the file
    exec `cat ${WFILE2} | awk 'BEGIN{RS="Fix"}{printf $3" "$4" "$5" "$6"\n"}' | grep -v Liberty > ${WRESULT}`
    #Change text "Comments" to "Releasing date"
    exec `sed -i 's/Comments/Releasing\ date/g' ${WRESULT}`
    #Print the 3rd line into a file which contains the newest fixpack
    exec `sed -n '3 p' ${WRESULT} > $WNEWEST`
}

function Report(){
    #Put the current day and month (with uppercase) into a local variable (within the function only)
    local WCURDATE=`date +%d%^b`
    #if the current date is 1st of JAN,APR,JUL or NOV send an email about fixpacks calling snedmail9.sh script
    case $WCURDATE in
	"01JAN")
	source $WORKDIR/sendmailv9.sh
	;;
	"01APR")
	source $WORKDIR/sendmailv9.sh
	;;
	"01JUL")
	source $WORKDIR/sendmailv9.sh
	;;
	"01NOV")
	source $WORKDIR/sendmailv9.sh
	;;
    esac
}

function GetTheNewest() {
    #Get the newest fixpack number
    local WFIXPACK=`cat ${WNEWEST} | cut -d " " -f1`
    #Get the release day of fixpack
    local WDAY=`cat ${WNEWEST} | cut -d " " -f2`
    #Get the release month of fixpack
    local WMONTH=`cat ${WNEWEST} | cut -d " " -f3`
    #Get the release year of fixpack
    local WYEAR=`cat ${WNEWEST} | cut -d " " -f4`
    #Format the date 
    local WDATE=$WDAY$WMONTH$WYEAR
    #Get the current date
    local WCURDATE=`date +%d%^b%Y`
    #If the fixpack releasing date is equal to the current date send an information mail about it calling sendmailnewv9.sh script
    if [ $WDATE == $WCURDATE ]; then
	#Creating the message of the mail, put into a file
	echo "Hello team!" > $WNEWEST
	echo -n "The following fixpack for Websphere V9 is available: " >> $WNEWEST
	echo $WFIXPACK >> $WNEWEST
	echo "For more information about fixlist go to http://www-01.ibm.com/support/docview.wss?uid=swg27048591" >> $WNEWEST
	echo "Regards," >> $WNEWEST
	echo " " >> $WNEWEST
	echo "Sent by Roland Mayherr automated script" >> $WNEWEST
	source $WORKDIR/sendmailnewv9.sh
    fi
}

#Call GetHtml function
if ! [ -e "$LOG" ]; then
    touch $LOG
fi
GetHtml
#If the return code is 0 (OK) call ProcessHtml function
if [ "$?" == 0 ];then
    ProcessHtml
    #If the return code of ProcessHtml is 0 (OK) call the Report and GetTheNewest function
    if [ "$?" == 0 ];then
        Report
	GetTheNewest
    fi
else
    #If something goes wrong put a timestamp and a message about the failure into a logfile
    echo -n "There was a failure during downloading on " >> $LOG
    echo `date +%Y %B %d - %T` >> $LOG
fi

