#!/bin/sh                                                                       
                                                                                
INP=$1                                                                          
D="/data/WebSphere/wxadomain/wxa51node/as/profiles/default/config/cells"        
OUT="result.txt"                                                                
                                                                                
function find_xml {                                                             
  find $D -name *.xml > $OUT                                                    
}                                                                               
                                                                                
function search_word {                                                          
  echo "Search pattern "$INP                                                    
  while read -r i;                                                              
   do                                                                           
     echo "in file "$i                                                          
     echo "-----------------------------"                                       
     iconv -f ISO8859-1 -t IBM-1047 ${i} | grep ${INP}                          
     echo "-----------------------------"                                       
   done < $OUT                                                                  
}                                                                               
                                                                                
search_word                                                                     