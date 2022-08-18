#!/usr/bin/env bash

IFS=$'\n'
#LongestLine=`cat /etc/group | wc -L`
LongestLine=`cat $1 | wc -L`
LongestLine=$(($LongestLine + 1))
BeforeLastChar=$(($LongestLine + 2)) 
End=$(($LongestLine + 1))
End2=$(($LongestLine + 2))

function printHeader() {
    echo -n "+"
    for i in $(seq 1 ${End2})
     do
	if [ $BeforeLastChar == $i ];
	 then
	  echo -n "+"
	  break
	else
          echo -n "-"
        fi
     done
}

function FormatLine() {
    echo ""
    #String=`cat /etc/group`
    String=`cat $Input`
    for i in $String
     do 
     LineWidth=`echo "$i" | wc -m`
     EmptySpace=$(($End - $LineWidth))
     echo -n "| "$i
     for j in $(seq 0 ${EmptySpace})
      do
        if [ $EmptySpace == $j ];
         then
          echo -n "|"
          break
	else
	  echo -n " "
	fi
      done
     echo "" 
     done
}

function printFooter() {
    echo -n "+"
    for i in $(seq 1 ${End2})
     do
	if [ $BeforeLastChar == $i ];
	 then
	  echo -n "+"
	  break
	else
          echo -n "-"
        fi
     done
}

#set -x
warg=$#
#echo $warg
case $warg in
    "0")
	echo "0 argument.Give one inputfile as an argument!"
    ;;
    "1")
	Input=$1
	printHeader
	FormatLine
	printFooter
	echo ""
    ;;
    *)
        echo "Usage: Give one inputfile as an argument!"
    ;;
esac
#set +x
