#!/bin/bash

# WRKPTFGRP <  shows the existing GroupPtf-packages on the System
groupptfs=( SF99876 SF99875 SF99730 SF99729 SF99728 SF99727 SF99725 SF99724 SF99723 SF99722 SF99703 )

# declare the path, where I'll download the actual website 
path='/tmp/'

# for differing the text with colors
green=$(tput setaf 2; tput bold)
white=$(tput setaf 7; tput bold)
none=$(tput sgr 0)

echo -e "     + -------- ${white}Installierte PTF-Groups auf dem ATIBMCC1${none} --------- +
     |     Get acual data from IBM website in: ‘/tmp/data.txt’     |\n\
     |  ${green}This shows You the actual Group-Ptf-refresh package Levels${none} |\n \
    |                IBM i Group PTFs with level                  |
     + --------->>  ${green}WRKPTFGRP PTFGRPLVL(*INSTALLED)${none}  <<----------- +"

# this is the site where the groupptfs are listed, and now we get it into /tmp as data.txt
wget "http://www-01.ibm.com/support/docview.wss?uid=nas4PSPbyNum" -q -O ${path}data.txt

# this is the table what we will filtering with the ARRAY: groupptfs (row:4)
dbase=${path}data.txt

# the filter() function cleans the html-tags from the data.txt
filter () 
{ grep --color nowrap $dbase | sed 's/<[^<]*.>//g;s/     //g;s/ *$//g;/^$/d;s/ $//g;s/ /_/g;s/^R/---R/g' | awk 'BEGIN{RS="---"}{print $1,$2,$3,$4}' | sed 's/_SF[0-9]*//g;s/:_/ /g;' | awk '{printf "%4s %7s %-44s %-11s %5s", $1,$2,$3,"level "$4,$5"\n"}' | grep --color -v "R610\|Last_Updated" | sort -k1 | sed '/    $/d'
}

echo

# here where the cleared data will shows only the packages in the ARRAY: groupptfs
# let's get the actual levels data:
for i in ${groupptfs[@]}
    do filter | grep $i | egrep --color 'SF..... | level ..... '
    sleep 0.2
done

rm -v $dbase
echo
