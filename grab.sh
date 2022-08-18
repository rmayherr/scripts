#!/usr/bin/env bash

IFS=$'\n'
FILE=$(mktemp)
WORIG=$(mktemp)
WLNG=""
ERRMSG="Something went wrong.Try again."
#################################################################
#Usage: add this program to Linux by creating shortcut		#
#for the script. For example: Associate Ctrl+T to grab.sh	#
#Then use it by selecting text you want Ctr+C and Ctrl+T	#
#Commandline translator is needed for the script		#
#How to download trans: wget git.io/trans			#
#Thenafter make it executable: chmod +x trans			#
#################################################################

function GetText {
    exec `xclip -o > $WORIG`
    exec `cat $WORIG > $FILE`
}
function IdentifyLang {
    WILNG=`trans -identify -i $WORIG | grep Code | awk '{print $2}'`
    #echo ${WILNG:4:2}
}
function SplitText {
    exec `echo "" >> $FILE`
    echo "+--------------------------------------+" >> $FILE
    echo $WLNG >> $FILE
    echo "+--------------------------------------+" >> $FILE
    exec `echo "" >> $FILE`
}
function TEnglish {
    WLNG="English"
    SplitText
    exec `trans -t en -b < $WORIG >> $FILE`
}
function TGerman {
    WLNG="Deutsch"
    SplitText
    exec `trans -t de -b < $WORIG >> $FILE`
}
function THungarian {
    WLNG="Magyar"
    SplitText
    exec `trans -t hu -b < $WORIG >> $FILE`
}
function OpenBrowser {
    exec google-chrome-stable $FILE &
    sleep 3
}
function CleanUp {
    exec `rm $FILE $WORIG`
}
#exec `notify-send -t 10000 $a`
GetText
IdentifyLang
case ${WILNG:4:2} in
    hu)
	TEnglish
	TGerman
	OpenBrowser
    ;;
    de)
	TEnglish
	THungarian
	OpenBrowser
    ;;
    en)
	TGerman
	THungarian
	OpenBrowser
    ;;
    *)
    ERRMSG=$ERRMSG" "$WILNG
    exec `notify-send -t 10000 $ERRMSG`
    ;;
esac
CleanUp