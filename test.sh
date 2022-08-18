#!/usr/bin/env bash

#head /etc/passwd >> info.log 2>&1 
#head /etc/shadow >> info.log 2>&1 

function test1() {
    echo "words..."
}

function test2() {
    curl http://youasdd.hu 
}

test1
if [ "$?" == 0 ]; then
    echo "return 0"
else 
    echo "return 1"
fi
test2
if [ "$?" == 0 ]; then
    echo "return 0"
else
    echo "return 1"
fi

