#!/usr/bin/env bash

######################################################################### 
# Purpose of the script is to get the available date and time from the	#
# verbosegc log file.							#
# After selecting a date the script will display you the available times#
# You can type "FROM" time and "TO" time passing those paramaters to	#
# gcselect.sh script,which query original verbosegc log with the time 	#
# frame given then edit and put the result into a new file		#
# Usage: ./gcrange.sh filename						#
#########################################################################

IFS=$'\n'
#Put first argument into variable
A=$1
#Temporary file
fa="a.txt"
#Temporary file
fb="b.txt"
#Temporary file
fc="c.txt"
#Temporary file
fd="d.txt"
#Temporary file
fe="e.txt"
#Temporary file, contains the date of file
fout="out.txt"
#Temporary file, contains the date of menu items
menu="menu.txt"
#Name of the script to be called
scriptname="gcselect.sh"

function CreateFile(){
    #Selecting the date and put into a file
    exec `cat ${A} | grep timestamp | cut -d"\"" -f4 | cut -d"T" -f1 > ${fa}`
    #Selecting the time and put into a file
    exec `cat ${A} | grep timestamp | cut -d"\"" -f4 | cut -d"T" -f2 > ${fb}`
    exec `cat ${fb} | cut -d":" -f1,2 > ${fc}`
    #Merge to files into one
    exec `paste ${fa} ${fc} > ${fd}`
    #Cleanup file
    exec `rm ${fa} 2> /dev/null`
    #Cleanup file
    exec `rm ${fb} 2> /dev/null`
    #Cleanup file
    exec `rm ${fc} 2> /dev/null`
    #Remove duplicates
    exec `cat ${fd} | grep : | uniq > ${fe}`
    #Convert tab to space
    exec `expand -t1 ${fe} > ${fout}`
    #Cleanup file
    exec `rm ${fd} 2> /dev/null`
    #Cleanup file
    exec `rm ${fe} 2> /dev/null`
}
function DateMenu(){
    wnum=1
    exec `rm ${menu} 2> /dev/null`
    echo "Which date do you want to use?"
    echo "Type [Exit] then press [Enter] to terminate the program."
    #Print the menu
    for i in `cat $fout | cut -d" " -f1 | uniq`
        do
        echo -n $wnum"."
        echo $i
        echo -e $i >> $menu
        let wnum++
        done
}
function ShowAvailableTime(){
    #Display the available times from given date
    for k in `cat $fout | grep ${wanswerdate} | cut -d" " -f2`
	do
	    echo -n $k" "
	done
}
function CheckFile(){
    if [ -e $A ];then
	return 0
    else
	echo "No such file!"
	return 1
    fi
}
function CheckTimeValidity(){
    WCTIME=`date --date=${wtime1} +%H:%M 2> /dev/null`
    if [[ $? > 0 ]];then
	echo "Invalid time!It's not real."
	return 1
    else
	return 0
    fi
}
function CheckTimeValidity2(){
    WCTIME2=`date --date=${wtime2} +%H:%M 2> /dev/null`
    if [[ $? > 0 ]];then
	echo "Invalid time!it's not real."
	return 1
    else
	return 0
    fi
}
function Check2Time(){
    WFROMT=`date --date=${wtime1} +%s`
    WTOT=`date --date=${wtime2} +%s`
    if [[ $WFROMT -gt $WTOT ]];then
	echo "'To' time is less then the 'from' time."
	return 1
    else
	return 0
    fi
}
if [[ $? == 1 ]];then
    exit
else
    CreateFile
    while true ;
	do
	    DateMenu
	    read -p "Type the number of date then press [Enter]:" wanswer
	    if [[ $wanswer == "Exit" ]];then
		exit
	    else
		wrow=1
		#values of the menu is stored in a file 
		for j in `cat $menu`
		    do
			#After choosing a value from menu it looks for the value for it
			if [[ $wanswer == $wrow ]];then
			    wanswerdate=$j
			fi
		    let wrow++
		    done
		wrow=1
		#echo "num "${wanswer:0:1}" date "$wanswerdate
		ShowAvailableTime
		echo ""
		break
	    fi
	done
    wexit=0
    while true ;
	do
	    echo "Do you want to get the values between a time frame?"
	    echo "Type [Exit] then press [Enter] to terminate the program."
	    #Get the interval from user input 
	    read -p "Give the [FROM] time: " wtime1 
	    read -p "Give the [TO] time: " wtime2
	    if [[ $wtime1 == "Exit" || $wtime2 == "Exit" ]];then
		exit
	    else
		CheckTimeValidity
		if [[ $? == 1 ]];then
		    exit
		else
		    CheckTimeValidity2
		    if [[ $? == 1 ]];then
			exit
		    else
			Check2Time
			if [[ $? == 1 ]];then
			    exit
			else
			    #Pass parameter the script and call it
			    echo "Calling script ./"$scriptname" "$wanswerdate","$wtime1" "$wanswerdate","$wtime2" "$A
			    source ${scriptname} ${wanswerdate},${wtime1} ${wanswerdate},${wtime2} ${A}
			    break
			fi
		    fi
		fi
	    fi
	done
fi