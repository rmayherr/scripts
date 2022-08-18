#!/usr/bin/env bash

#Catch signal 2
trap val 2
val(){
    clear
    echo "You forced to quit!I cannot allow you it :)"
    func1
    exit 
}
func1(){
    read -p "Give me a number: " num
    echo "Value is 10, if you did not enter nothing: ${num:=10}"
}
func1