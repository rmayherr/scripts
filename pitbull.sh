#!/bin/bash
SITE='https://aranyoldalak.hu'
SOR='------------------------------------------------'

if [ -z $1 ]; then
    read -p 'Add meg a szakmát amit keresni akarsz: ' KEY
    read -p 'Add meg a várost ahol keresni szeretnél: ' CITY
elif [ -z $2 ]; then
    CITY='szekesfehervar'
else
    KEY=$1
    CITY=$2
fi

TEMP=$(mktemp)

echo $TEMP

#downloading te first site
curl $SITE/$KEY/$CITY/ -o $TEMP

#if there are more than one page, we whant to know the number 
P=$(cat $TEMP | grep -o '[[:digit:]]/[[:digit:]] oldal')
# the count of the pages
P_NR=${P:2:2}

# with this for loop we append the other pages in the $TEMP file
for ((i=2;i<=${P_NR};i++));
    do
    curl $SITE/$KEY/$CITY/${i}-oldal/ >> $TEMP
    done

clear

# now sorting the information
cat -n $TEMP | sed 's/[[:lower:]]*:/\n&/g'| \
egrep 'position:|addr:|title:|tel:' | \
sed 's/">//g' | \
sed 's/position:/ &  /g;s/addr:/ &      /g' |\
sed 's/title:/ &     /g;s/tel:/ &       /g;s/'\''//g' |\
sed 's/tel.*/&\n'${SOR}'/g' | \
egrep 'position:|addr:|title:|tel:|--' 


# removing the appended temp file
rm $TEMP
