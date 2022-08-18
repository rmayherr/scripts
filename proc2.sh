#!/usr/bin/env bash

IFS=$'\n'
nodeName="wasgqn01"
serverName="sgq0101"
filePath="./modify.txt"
for i in `ls . --format=single-column --hide=*.sh`
    do
	#Every line should start with '
	result="'"
	for j in `cat $i`
	    do
		#looking for word "node" in the current string in position at 1-4, if it's found, change the string with the value 
		if [[  ${j:1:4} == "node" ]];then
		    j="-node "${nodeName}" "
		    #Append a string to the variable
		    result+=$j
		#looking for word "server" in the current string at position 1-6, if it's found, change the string with the value 
		elif [[  ${j:1:6} == "server" ]];then
		    j="-server "${serverName}" "
		    #Append a string to the variable
		    result+=$j
		#looking for a specific word "uuid" in the string,if it's found, omit that string, do  nothing
		elif [[  ${j:1:4} == "uuid" ]];then
		    continue
		#looking for a specific word "localizationPointRefs" in the string at position 1-21,if it's found, omit that string, do  nothing
		elif [[  ${j:1:21} == "localizationPointRefs" ]];then
		    continue
		#looking for character "[]" at the end of the string ,if it's found, omit that string, do  nothing
		elif [[  ${j: -2} == "[]" ]];then
		    continue
		#looking for character "]]" at the end of the string ,if it's found, omit that string, do  nothing
		elif [[  ${j: -2} == "]]" ]];then
		    continue
		else
		    #How long is the current string?
		    len=${#j}
		    #The last character of string is always "]", it's not needed, should be trimmed
		    len=$(($len - 2 ))
		    #echo "trimmed: "${j:1:$len}
		    #Append a string to the variable
		    result+="-"${j:1:$len}" "
		fi
	    done
	#End of the string a character ' should be added
	result+="'"
	#write and append to a file
	echo $result >> createnew.txt
    done

