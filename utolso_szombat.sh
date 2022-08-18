#!/bin/bash
clear
tput setab 2; tput setaf 7; tput bold
echo -e "\n\tÍrd be számmal (pl:2020)\n\tmely évben akarod\n\ta hónapok utolsó szombatjait kiíratni\n\talapértelmezett ez az év"
tput sgr0

read ev

clear

if [[ $(echo ${#ev}) -lt 1 ]]; then
    ev=$(date +%Y)
    else
    ev=$ev
    fi

vonal=" + --------------------------------------------- + "

message="$vonal\n | A $ev -as év hónapjainak utolsó szombatjain  | \
\n | havi mentések indulnak a TRW rendszereken.    | \n$vonal"

tput setab 1; tput setaf 7; tput bold
echo -e "\n$message\n"
tput sgr0

monthly(){
for i in {1..12};
do
    if [ $i -eq 2 ]; then
        cal -m $i $ev | head -1 | sed 's/ * //g' | cut -c -3;
        tput setab 2; tput setaf 7; tput bold
        cal -m $i $ev | awk '$6 > 22 {print " "$6}' | tail -1;
        tput sgr0
    else
        cal -m $i $ev | head -1 | sed 's/ * //g' | cut -c -3;
        tput setab 2; tput setaf 7; tput bold
        cal -m $i $ev | awk '$6 > 24 {print " "$6}' | tail -1; 
        tput sgr0
    fi;
done
}
monthly
# Blue background message on the right side
tput setab 4; tput setaf 7
tput cup 7 12; echo -e " + --------------------- + "
tput cup 8 12; echo -e " |  Egy kiragadott példa | " 
tput cup 9 12; echo -e " |  hogy ellenőrizhesd:  | " 
tput cup 10 12; echo -e " + --------------------- + "
tput sgr0
# only blue characters, without backgroundcolor
tput setaf 4; tput bold
tput cup 11 8; cal -m 03 $ev | head -1
tput cup 12 13; cal -m 03 $ev | head -2 | tail -1
tput cup 13 13; cal -m 03 $ev | tail -2  | head -1
tput cup 14 13; cal -m 03 $ev | tail -1
tput cup 31 0;
tput sgr0
