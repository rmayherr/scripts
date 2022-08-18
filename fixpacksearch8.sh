#!/usr/bin/env bash

#HOME="/IBM_Data"
#WORKDIR="$HOME/linux"
WORKDIR=$(pwd)
WFILE="$WORKDIR/wasv8.txt"
WFILE2="$WORKDIR/wtempv8.txt"
WRESULT="$WORKDIR/resultv8.txt"
WNEWEST="$WORKDIR/newestv8.txt"
LOG="$WORKDIR/statusv8.log"

function GetHtml() {
    curl https://www.ibm.com/support/pages/recommended-updates-websphere-application-server -o $WFILE > /dev/null 2>&1
}

function HtmlProcessing() {
#    set -x 
    #WROW=`cat ${WFILE} | nl | grep '<b>Version 8.5.5</b>' | cut -d "<" -f 1` | tr -d ' '
    #exec `sed -n ' '"${WROW}"',/<b>Additional information/p' ${WFILE} > ${WFILE2} `
    exec `sed -n '/<b>Version 8.5.5<\/b>/,/Refresh pack 8.5.5/p' ${WFILE} > ${WFILE2}`
    #exec `sed -i 's/<[^<]*>//g' ${WFILE2}`
    exec `sed -i '' 's/<[^<]*>//g' ${WFILE2}`
    exec `cat ${WFILE2} | awk 'BEGIN{RS="Fix"}{printf $3" "$4" "$5" "$6" "$7"\n"}' | grep -Ev 'for|Released|see' > ${WRESULT}`
    exec `cat ${WRESULT} | grep -E '^[0-9]' | head -n3 | cut -d ' ' -f 2,3,4,5 > ${WNEWEST}`
    #exec `sed -i 's/Comments/Releasing date/g' ${WRESULT}`
    #exec `sed 's/Comments/Releasing date/g' ${WRESULT}`
    #exec `sed -n '3 p' ${WRESULT} > $WNEWEST`
 #   set +x
}

function Report(){
    #local WCURDATE=`date +%d%^b`
    local WCURDATE=`date`
    case $WCURDATE in
	"01JAN")
	source $WORKDIR/sendmailv8.sh
	;;
	"01APR")
	source $WORKDIR/sendmailv8.sh
	;;
	"01JUL")
	source $WORKDIR/sendmailv8.sh
	;;
	"01NOV")
	source $WORKDIR/sendmailv8.sh
	;;
    esac
}

function GetTheNewest() {
    local WFIXPACK=`cat ${WNEWEST} | cut -d " " -f1`
    local WDAY=`cat ${WNEWEST} | cut -d " " -f2`
    local WMONTH=`cat ${WNEWEST} | cut -d " " -f3`
    local WYEAR=`cat ${WNEWEST} | cut -d " " -f4`
    local WDATE=$WDAY$WMONTH$WYEAR
#    local WCURDATE=`date +%d%^b%Y`
    local WCURDATE=`date`
    if [[ $WDATE == $WCURDATE ]]; then
	echo "Hello team!" > $WNEWEST
        echo -n "The following fixpack for Websphere V8 is available: " >> $WNEWEST
        echo $WFIXPACK >> $WNEWEST
        echo "For more information about fixlist go to http://www-01.ibm.com/support/docview.wss?uid=swg27036319" >> $WNEWEST
        echo "Regards," >> $WNEWEST
        echo " " >> $WNEWEST
        echo "Sent by Roland Mayherr automated script" >> $WNEWEST
        #source $WORKDIR/sendmailnewv8.sh
    fi
}

if ! [ -e $LOG ]; then
    touch $LOG
fi 
GetHtml
if [ "$?" == 0 ];then
    HtmlProcessing
    if [ "$?" == 0 ];then
	Report
	GetTheNewest
    fi
else
    echo -n "There was a failure during downloading on " >> $LOG
#    echo `date +%Y %B %d - %T` >> $LOG
    echo `date` >> $LOG
fi
