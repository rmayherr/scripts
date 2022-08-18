#!/bin/sh                                                                                           
ROOTDIR="/var/WebSphere"                                                                            
TMP="/tmp/lsdr.txt"                                                                                 
                                                                                                    
#Check whether env is given                                                                         
if                                                                                                  
   test $# -ne 1                                                                                    
then                                                                                                
   echo "You must provide the environment identifier as an argument.\n i.e. ./ownset.sh ut"         
else                                                                                                
   ENV=$1                                                                                           
   if                                                                                               
#Check the existence of the directory                                                               
     test -d $ROOTDIR/$ENV                                                                          
    then                                                                                            
       echo $ROOTDIR/$ENV" directory exists.\n"                                                     
#Grab directories and their groups                                                                  
       ls -l $ROOTDIR/$ENV | awk 'FNR > 1 {print $4,$9}' | tr [a-z] [A-Z] > $TMP                    
       IFS='  '                                                                                     
       while read groupname dirname                                                                 
       do                                                                                           
          echo "directory "$dirname" has group "$groupname" set."                                   
#          ENVID=$(echo $ENV | awk '{$1 = substr($1,1,1)} 1' | tr [a-z] [A-Z])                       
           ENVID=$(echo $ENV | awk '{$1 = substr($1,1,1)} 1'                     
           NEWGRP="F#"$dirname$ENVID"A2"                                                             
          if ! test $dirname = "BNW"                                                                
          then                                                                                      
            if ! test $groupname = $NEWGRP                                                          
            then                                                                                    
#Change the group if it is not match F#<APPL><ENV>A2 syntax                                         
#Uncomment the command below. Be aware it can cause trouble                                         
#             chgrp -R $NEWGRP $ROOTDIR/$ENV/$dirname                                                             
              echo "chgrp -R command issued "$NEWGRP" on dir "$dirname                              
            else                                                                                    
              echo $dirname" has correct group "$groupname                                          
            fi                                                                                      
          fi                                                                                        
          echo ""                                                                                   
       done <$TMP                                                                                   
    else                                                                                            
       echo "There is no "$ROOTDIR/$ENV" directory."                                                
   fi                                                                                               
fi                                                                                                  
#Cleanup                                                                                            
if test -f $TMP                                                                                     
  then rm $TMP                                                                                      
fi                                                                                                  