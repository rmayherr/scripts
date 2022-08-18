#!/usr/bin/env bash


function dump {
	SRC="/MyThinClient/"
	EXLIST=()
	case ${#EXLIST[*]} in
	    0)
		echo "0 element will be excluded form copy of "$SRC
		EXSTR=""
	    ;;
	    1)
		echo ${#EXLIST[*]}" element will be excluded from copy of "$SRC
		EXSTR="--exclude="${!EXLIST[0]}
	    ;;
	    *)
		echo ${#EXLIST[*]}" elements will be excluded from copy of "$SRC
		for i in ${!EXLIST[*]}
		do
		    EXSTR=$EXSTR" --exclude="${EXLIST[i]}" "
		done
	    ;;
	esac	
	SIZE=`du -hs --exclude=plugins --exclude=java ${SRC} | cut -d "/" -f1`
	if [[ $SIZE == " "  ]];then
	    echo "Error occurred!Exit."
	else
	    echo "Copying "$SRC" to "$TRG${SRC:1}" with size "$SIZE
#	    rsync -azh $EXSTR --stats $SRC $TRG${SRC:1}
	    rsync -azhR $EXSTR --stats $SRC $TRG$
	fi
}
function dump2 {
	SRC="/home/rmayherr/"
	EXLIST=(".Trash" "fontconfig" "lotus" "Music" "Public" "Recycle" "SameTimeRooms" "Templates" "Videos" ".adobe" ".cache" ".g*" ".mozilla" ".gconf")
	case ${#EXLIST[*]} in
	    0)
		echo "0 element will be excluded form copy of "$SRC
		EXSTR=""
	    ;;
	    1)
		echo ${#EXLIST[*]}" element will be excluded from copy of "$SRC
		EXSTR="--exclude="${!EXLIST[0]}
	    ;;
	    *)
		echo ${#EXLIST[*]}" elements will be excluded from copy of "$SRC
		for i in ${!EXLIST[*]}
		do
		    EXSTR=$EXSTR" --exclude="${EXLIST[i]}" "
		done
	    ;;
	esac	
	SIZE=`du -hs --exclude=plugins --exclude=java ${SRC} | cut -d "/" -f1`
	if [[ $SIZE == " "  ]];then
	    echo "Error occurred!Exit."
	else
	    echo "Copying "$SRC" to "$TRG${SRC:1}" with size "$SIZE
#	    rsync -azh $EXSTR --stats $SRC $TRG${SRC:1}
	    rsync -azhR $EXSTR --stats $SRC $TRG
	fi
}

if [ `id | cut -d"(" -f1` != "uid=0" ];then
    echo "Script is running with not root priviledges!You might run with root."
fi
if [[ ! $# == 1 ]];then
	echo "Please give a path where the backup should be copied to."
else
	TRG=$1
	if [ -d $TRG ];then
	    dump
	    dump2
	else
	    echo "Invalid path!"
	fi
fi
