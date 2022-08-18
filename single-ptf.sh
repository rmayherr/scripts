#!/bin/bash

# what is working path directory:
thispath=$(echo $PWD)
#if the parameter was given sptf will be have the value of $1 parameter
sptf=$1
link='http://www-01.ibm.com/support/docview.wss?uid=nas3'

#if the number of parameters lack then the program asks for one:
if [[ $# -lt 1 ]]; then
     echo -e "Please type in the needed Sinlge PTF number; exmpl: SI69336\nThe number is:"
#here you'll declare the SinglePtf number: "SI69146" for example
     read sptf
fi

# checks file if result = 0 than exist; if result==1 file not exists
#[[ -f $(ls do*) ]] && echo $? || echo $?

del_file_if_exists(){
#take question from where and what will be deleted:
rm $thispath/doc* 2>/dev/null
}

#  -f check for a regular file //man bash "regular file"
[[ -f $(ls do* 2>/dev/null) ]] && del_file_if_exists && wget -P $thispath $what_to_get 2>/dev/null \
|| wget -P $thispath $what_to_get 2>/dev/null


# I join the link and the SinglePtfNumber together,
# This will be the website I'll wget local in the working path directory
what_to_get=${link}${sptf}

#wget -P $where   $what    2>do_not-send-me-message
wget -P $thispath $what_to_get 2>/dev/null
#get the LicensedProgramNumber
licpgm=$( echo $(grep -A1 'Licensed Program' $thispath/'doc'*) | tail -1 | sed -e 's/<[^>]*>//g' | cut -c 33- )

#make an iSeries compatible command
#for check wether on the checked system is installed or not 
echo 'DSPPTF LICPGM('${licpgm}')'

#remove the downloaded page
rm $thispath/doc* 2>/dev/null
