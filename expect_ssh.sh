#!/usr/bin/expect

#Set commandline arguments
set username [lindex $argv 0]
set password [lindex $argv 1]
#Set hostname
set ssh_host "192.168.54.20"
#Issue linux command
spawn ssh $username@$ssh_host -p 2222

#We expect the following response, send password then press Enter \r
expect "$username@$ssh_host\'s password:" {send "$password\r"}

#We expect $ prompt
expect "$ "

#List directories
send "ls -l\n"

#Exit from ssh
#send "exit\n"

#Interact command is mandatory
interact

