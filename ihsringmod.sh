######################################################################         
# Rename props files to props.tmp. Add new keyring key / value       #         
# to each entity,create a temporary file .ebcdic. Then convert that  #         
# file back to ascii, then clean up temporary files.                 #         
#                                                                    #         
# Author                                                             #         
# Roland Mayherr                                                     #         
#                                                                    #         
# Modification                                                       #         
#   20210203 Creation date                                           #         
######################################################################         
WORKDIR=/tmp/websrvprops                                                       
                                                                               
function mod_conf {                                                            
  for i in $WORKDIR/*.tmp                                                      
   do                                                                          
    newfile=$(echo $i |cut -c1-31)                                             
    echo "Set property for "$newfile                                           
    sed -W pgmcodeset=IBM-1047 's/IHSRING/SITEKEYRING/g'\                      
    $i > $i".ebcdic"                                                           
    iconv -f IBM-1047 -t ISO8859-1 $i".ebcdic" >$newfile                       
    rm $i".ebcdic"                                                             
    rm $i                                                                      
   done                                                                        
}                                                                              
function rename_files {                                                        
 for i in $WORKDIR/*.props                                                     
  do                                                                           
   echo "Rename "$i" to "$i".tmp"                                              
   mv -S a=.tmp $i $WORKDIR                                                    
  done                                                                         
}                                                                              
rename_files                                                                   
mod_conf                                                                       