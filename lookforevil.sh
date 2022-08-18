#!/bin/bash                                                       
LOGFILE="/var/zosconnect/lookforevil.log"                         
function searchfiles                                              
{                                                                 
  if test -d "$1"                                                 
  then                                                            
    echo "Searching files with permission 666" | tee -a $LOGFILE  
    echo "Setting permissions to 664..."                       
    for i in $(find $1 -perm 666)                                 
    do                                                            
      echo $i >> $LOGFILE                                         
      chmod 664 $i                                                
    done                                                          
    echo "done."                                                  
    return 0                                                      
  else                                                            
   echo "Wrong parameter! " $1 " is not a directory."             
   return 1                                                       
  fi                                                              
}                                                                 
searchfiles $1                                                    

