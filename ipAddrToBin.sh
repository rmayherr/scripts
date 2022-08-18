#!/usr/bin/env sh

#Check path of linux command
#IFCFG=`whereis -b ifconfig | cut -d ":" -f2 | tr -d " "`
IFCFG=`whereis ifconfig | cut -d ":" -f2 | tr -d " "`
#CALC=`whereis -b bc | cut -d ":" -f2 | tr -d " "`
CALC=`whereis bc | cut -d ":" -f2 | tr -d " "`
#Declare an array
declare -a ETHER

function getInterface {
#Get network interfaces and put them into array
#    for i in `$IFCFG -s|cut -d " " -f1`
    for i in `$IFCFG -l`
    do
        ETHER+=($i)
    done
}
function getIpAddress {
#Loop in array
    for ((i=0;i<${#ETHER[*]};i++))
    do
#Header must be ignored
	if (( $i == 0));then
	    continue
	else
#Create an array for ip address translation
	    declare -a OCTET		
	    BINET=""
#Grab octets of specific ip address
	    #INET=`$IFCFG ${ETHER[$i]} | grep -w inet | tr -s " " | cut -d " " -f3`
	    INET=`$IFCFG ${ETHER[$i]} | grep -E 'inet .?' | cut -d ' ' -f2`
	    if [[ $INET == "" ]];then
		echo "There is no ip address defined for "${ETHER[$i]} 
	    else	
#Separate octets into array
		for ((j=1;j<5;j++))
		do
		    OCTET[$j]=`echo $INET | cut -d"." -f$j `
		done
#Loop in array and convert decimmal numbers to binary and assemble them 
		for ((k=0;k<5;k++))
		do
		    BINET+=`echo 'obase=2;'${OCTET[$k]}'' | $CALC`
		    case $k in
			1|2|3)BINET+=".";;
		    esac
		done
		echo "Network interface "${ETHER[$i]}" ip address "$INET" in binary "$BINET
	    fi
	    unset OCTET
	fi
    done
}
#Call function to see network interfaces in the computer
getInterface
#How much interfaces found?
let TOTAL=${#ETHER[*]}-1
echo $TOTAL" interfaces found."
if [[ $? == 0 ]];then
#Calculate their ipv4 ip addresses to binary
    getIpAddress
else
    echo "Error occured during getting network interfaces!"
fi

