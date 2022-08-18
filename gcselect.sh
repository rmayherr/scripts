#!/usr/bin/env bash

#################################################################################
# The purpose of this script is to cut a piece of verbosgc information 		#
# given date/time interval. 							#
# Format is the following:							#
# ./gcselect 2018-05-07,10:00 2018-05-07,11:30 verbosegcfile.txt		#
# scriptname from date,time   to date,time     filename				#
#################################################################################


IFS=$'\n'
#W=$0
#actual directory
WORKDIR=$PWD
#first argument
WFROM=$1
#second argument
WTO=$2
#third argument
WFILE=$3
#create a temporary file /tmp/tmp.xxx
WTMPFILE=$(mktemp)
WREC=0
#Convert first parameter of date to day of year
WFROMJ=`date --date=${WFROM:0:10} +%j`
#Convert second parameter of date to day of year
WTOJ=`date --date=${WTO:0:10} +%j`
#Convert first parameter of time to seconds
WFROMT=`date --date=${WFROM:11:15} +%s`
#Convert second parameter of time to seconds
WTOT=`date --date=${WTO:11:15} +%s`

function CheckFirstArgument(){
    #echo $WFROM
    #Check the syntax of date and time
    if [[ $WFROM =~ ([0-9]{4})-([0-9]{2})-([0-9]{2}),[0-9]{2}:[0-9]{2} ]];then
	#echo "ok"
	return 0
    else
	echo "Invalid date format. Use the following pattern: YYYY-MM-DD,HH:MM"
	return 1
    fi
}
function CheckSecondArgument(){
    #echo $WTO
    #Check the syntax of date and time    
    if [[ $WTO =~ ([0-9]{4})-([0-9]{2})-([0-9]{2}),[0-9]{2}:[0-9]{2} ]];then
	#echo "ok"
	return 0
    else
	echo "Invalid date format. Use the following pattern: YYYY-MM-DD,HH:MM"
	return 1
    fi
}
function CheckDateValidity(){
    #Check whether given date is valid date
    WCDATE=`date --date=${WFROM:0:10} +%Y-%m-%d 2> /dev/null`
    #If date command gives error then it's an invalid date given
    if [[ $? > 0  ]];then
	echo "Invalid date!It's not real."
	return 1
    else
	#echo "Valid date."
	return 0
    fi
}
function CheckTimeValidity(){
    #Check whether given time is valid time
    WCTIME=`date --date=${WFROM:11:15} +%H:%M 2> /dev/null`
    #If date command gives error then it's an invalid date given
    if [[ $? > 0  ]];then
	echo "Invalid time!It's not real."
	return 1
    else
	#echo "Valid time."
	return 0
    fi
}
function CheckDateValidity2(){
    #Check whether given date is valid date
    WCDATE2=`date --date=${WTO:0:10} +%Y-%m-%d 2> /dev/null`
#    echo $WCDATE2
    #If date command gives error then it's an invalid date given
    if [[ $? > 0  ]];then
	echo "Invalid date!It's not real."
	return 1
    else
	#echo "Valid date."
	return 0
    fi
}
function CheckTimeValidity2(){
    #Check whether given time is valid time
    WCTIME2=`date --date=${WTO:11:15} +%H:%M 2> /dev/null`
#    echo $WCTIME2
    #If date command gives error then it's an invalid date given
    if [[ $? > 0  ]];then
	echo "Invalid time!It's not real."
	return 1
    else
	#echo "Valid time."
	return 0
    fi
}
function CheckThirdArgument(){
    #Check whether the file exists
    if [ -e $WFILE ];then
	#echo $WFILE
	return 0
    else 
	echo "No such file!"
	return 1
    fi
}
function Check2Date(){
    #Check whether the "to" date is less than the "from" date
    if [[ $WFROMJ -gt $WTOJ ]];then
	echo "'To' date is less than 'From' date."
	return 1
    else
	return 0
    fi
}
function Check2Time(){
    #Check whether the "to" time is less than the "from" time
    if [[ $WFROMT -gt $WTOT ]];then
	echo "'To' time is less than 'From' time."
	return 1
    else 
	return 0
    fi
}
function EditText(){
    echo "Processing "$WFILE
    WFILEBCK=$WFILE".orig"
    #Make a backup from original file with suffix .orig
    exec `cp ${WFILE} ${WFILEBCK} `
    #In which row is the end of the initial information
    WHDR=`cat ${WFILE} | nl | grep "</initialized>" | awk '{printf $1}'`
    #Cut the entire initial information into a temporary file
    exec `sed -n '1,'"${WHDR}"'p' ${WFILE} > $WTMPFILE`
    echo -n "Please wait..."
    #Start reading the file
    for i in `cat ${WFILE}`
	do
	    #If start recording..
	    if [[ $WREC == 1 ]];then
		#Append the content into the temporary file
		echo -e $i >> $WTMPFILE
	        if [[ ${i:0:14} == "<exclusive-end" ]];then
	    	    #Since the "timestamp" is always in different position needs to be searched the starting point
	    	    wpos=`awk -v str="$i" -v wsstr="timestamp" 'BEGIN{print index(str,wsstr)}'`
		    #Get date
	    	    wtmpdate=$(( $wpos + 10 ))
	    	    #Get time
	    	    wtmptime=$(( $wpos + 21 ))
	    	    #If the "to" date and time match in the line stop writing
		    if [[ ${WTO:0:10} == ${i:$wtmpdate:10} && ${WTO:11:5} == ${i:$wtmptime:5} ]];then
			WREC=0
		    fi
		fi
	    fi
	    if [[ ${i:0:16} == "<exclusive-start" ]];then
	    #If the "from" date and time match start writing into the temporary file
	    	    #Since the "timestamp" is always in different position needs to be searched the starting point
	    	    wpos=`awk -v str="$i" -v wsstr="timestamp" 'BEGIN{print index(str,wsstr)}'`
		    #Get date
	    	    wtmpdate=$(( $wpos + 10 ))
	    	    #Get time
	    	    wtmptime=$(( $wpos + 21 ))
	    	#If the "to" date and time match in the line start writing
		if [[ ${WFROM:0:10} == ${i:$wtmpdate:10} && ${WFROM:11:5} == ${i:$wtmptime:5} ]];then
		    WREC=1
		    echo -e $i >> $WTMPFILE
		fi
	    fi
	done
    #Create the name if the result file
    WOUT="$WORKDIR/output.`date +%Y%m%d.%H%M%S`.${WFILE:(-8)}.txt"
    #Copy the tempfile to result file
    exec `cp ${WTMPFILE} ${WOUT}`
    echo "Done."
    echo $WOUT" file has been created."
    #Remove temporary file
    rm $WTMPFILE
}
#Check whether exaclty 3 arguments are given
if ! [[ $# == 3 ]];then
    echo "Invalid paramateters!You have to give 3 arguments."
    echo "Usage: Date from[2018-03-24,22:45] Date to[2018-03-24,23:50] filename[example.txt]"
    break
else
    CheckFirstArgument
    if [[ $? == 1 ]];then
	exit
    else
        CheckDateValidity
        if [[ $? == 1 ]];then
		exit
	else
    	    CheckTimeValidity
    	    if [[ $? == 1 ]];then
		exit
	    else
		CheckSecondArgument
		if [[ $? == 1 ]];then
		    exit
		else
		    CheckDateValidity2
		    if [[ $? == 1 ]];then
			exit
		    else
			CheckTimeValidity2
			if [[ $? == 1 ]];then
			    exit
			else
			    CheckThirdArgument
			    if [[ $? == 1 ]];then
				exit
			    else
				Check2Date
				if [[ $? == 1 ]];then
				    exit
				else
				    Check2Time
				    if [[ $? == 1 ]];then
					exit
				    else
					EditText
				    fi
				fi
			    fi
			fi
		    fi
		fi
	    fi
	fi
    fi
fi
