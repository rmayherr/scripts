#!/bin/bash

path='/tmp'
#if the parameter was given sptf will be have the value of $1 parameter
sptf=$(echo $1 | tr 'a-z' 'A-Z')
link='http://www-01.ibm.com/support/docview.wss?uid=nas3'
white=$(tput setaf 7; tput bold)
red=$(tput setaf 1; tput bold)
green=$(tput setaf 2; tput bold)
none=$(tput sgr 0)


#if the number of parameters lack then the program asks for one:
###echo -e "\nYou can easily get the Licenced Program code:"
if [[ $# -lt 1 ]]; then
     echo -e $red"\nPlease type in the Sinlge PTF number\nyou whant to find out its Licenz Number; \n\
for example: ${white}SI69336 ${green} (case insensitive)"
#here you'll declare the SinglePtf number: "SI69146" for example
     read -p "The number is: " sptf
     sptf=$(echo $sptf | tr 'a-z' 'A-Z')
fi

#  -f checks for a regular file not exists ! [ ... ]//man bash "regular file"
! [ -f $(ls ${path}doc* 2>/dev/null) ] && wget -P $path $what_to_get -P $path 2>/dev/null

# I join the link and the SinglePtfNumber together,
what_to_get=${link}${sptf}


#wget -P $where   $what    2>do_not-send-me-message
wget -P $path $what_to_get 2>/dev/null
#get the LicensedProgramNumber
licpgm=$( echo $(grep -A1 'Licensed Program' $path/'doc'*) | tail -1 | sed -e 's/<[^>]*>//g' | cut -c 33- )

#make an iSeries compatible command
#for check wether on the checked system is installed or not 
###echo -e "\n${none}Here your iSeries command:\n"
echo -e "${green}DSPPTF LICPGM(${licpgm})"

#remove the downloaded page
rm $path/doc* 2>/dev/null
