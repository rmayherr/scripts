#!/usr/bin/env bash

A=("java" "plugin" ".file")
echo "items: "${#A[*]}
for i in ${!A[*]}
do
    B=$B" --exclude="${A[i]}
done

echo $B