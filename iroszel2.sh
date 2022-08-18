#!/usr/bin/env bash

#for i in {1..20}; do 
#	echo "$i" 
#done | awk 'NR %2 == 0' #páros sorok


for i in {1..20}; do 
	let "a=${i} % 2"
	if [[ $a == 0 ]]; then
	    echo "$i"
	fi
done 
