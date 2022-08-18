#!/usr/bin/env bash

IFS=$'\n'
for i in `cat $1`
    do
	if [[ ${i:0:16} == "<exclusive-start" || ${i:0:14} == "<exclusive-end" ]] ;then
	    wsstr="timestamp"
	    wpos=`awk -v str="$i" -v wsstr="$wsstr" 'BEGIN{print index(str,wsstr)}'`
	    #echo $wpos
	    if [[ $wpos > 0 ]];then
		wstrpos=$(( $wpos + 10 ))
		wstrpos2=$(( $wpos + 21 ))
		echo "print timestamps: "${i:$wstrpos:10}" "${i:$wstrpos2:5}
	    fi
	fi
    done
