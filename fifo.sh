#!/bin/sh

QUEUE="/tmp/pisti_queue"

put_queue(){
    for i in {1..20};do
        MESSAGE='Pisti feladat'$i
        echo $MESSAGE >> $QUEUE
    done
}

get_queue(){
        cat $QUEUE
}

test -e $QUEUE && `exec rm $QUEUE` || mkfifo $QUEUE
put_queue
get_queue
