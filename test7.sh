#!/usr/bin/env bash

#Catch CTRL+C signal by using trap command
trap val 2
val(){
    clear
    echo "You forced to quit!I cannot allow you it :)"
    func1
    exit 
}
func1(){
    read -p "Give me a number: " num
#If you don't type anything, default value will be used
    echo "Value is 10, if you did not enter nothing: ${num:=10}"
}
func1