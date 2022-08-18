#!/usr/bin/env bash

SCRIPTNAME=$1
FILENAME=`echo ${SCRIPTNAME} | cut -d '.' -f1`
FILENAME=$FILENAME"_requirements.txt"

if [[ $# == 1 ]]; then
	if test -e $SCRIPTNAME ; then
		if test -e $FILNAME; then
			rm $FILENAME
		fi
		cat $SCRIPTNAME | sed -n '/^from/p' | cut -d ' ' -f2 | cut -d '.' -f1 | uniq >> $FILENAME
		cat $SCRIPTNAME | sed -n '/import/p' | cut -d ' ' -f2 | cut -d '.' -f1 | uniq >> $FILENAME
		cat $FILENAME | sort |  uniq > "temp_"$SCRIPTNAME
		cat "temp_"$SCRIPTNAME > $FILENAME
		echo "required modules saved to "$FILENAME
	fi
fi

