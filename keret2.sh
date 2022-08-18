#!/usr/bin/env bash

IFS=$'\n'
#LongestLine=`cat /etc/group | wc -L`
LongestLine=`/usr/bin/xclip -o | wc -L`
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
    for i in $Input
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
Input=`/usr/bin/xclip -o`
printHeader
FormatLine
printFooter
echo ""
#set +x
