#!/usr/bin/env bash

IFS=$'\n'
nodeName="wasgqn01"
serverName="sgq0101"
filePath="./modify.txt"
for i in `ls . --format=single-column --hide=*.sh`
    do
	result="('"
	for j in `cat $i`
	    do
		if [[  ${j:1:4} == "node" ]];then
		    j="[node "${nodeName}"]"
		    result+=$j
		elif [[  ${j:1:6} == "server" ]];then
		    j="[server "${serverName}"]"
		    result+=$j
		elif [[  ${j:1:21} == "localizationPointRefs" ]];then
		    continue
		elif [[  ${j: -2} == "[]" ]];then
		    continue
		elif [[  ${j: -2} == "]]" ]];then
		    continue
		elif [[  ${j:1:4} == "uuid" ]];then
		    continue
		else
		    result+=$j
		fi
	    done
	result+="')"
	echo $result >> modify.txt
    done

