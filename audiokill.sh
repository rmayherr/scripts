#!/usr/bin/env bash

function killAudio() {
    echo "killing PID and its name " `ps -C pulseaudio -o pid,command | tail -n1`
    kill `ps -C pulseaudio -o pid | tail -n1`
}

function startPulseaudio() {
    echo "Starting pulseaudio.."
    pulseaudio --system &
}

if [[ `id | cut -d "(" -f1 | cut -d "=" -f2` -eq "0" ]];then
    while true
    do
	if [[ `ps -C pulseaudio -o pid | tail -n1` -ge "1" ]];then
	    killAudio
	else
	    break
	fi
    done
    startPulseaudio
else
    echo "You must run the script under root!"
fi
