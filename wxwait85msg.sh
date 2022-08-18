#!/bin/sh                                                                                                
#wxwait85.msg                                                                                            
function getOldVersion {                                                                                 
  OLDVER=`cat wxwait85.msg | grep "8.5.5." | cut -d "." -f6`                                             
  echo "Old service level is 8.5.5."$OLDVER                                                              
}                                                                                                        
function getVersion {                                                                                    
  #WXUWAITPATH="/data/WebSphere/wxudomain/home/FWXUCT"                                                   
  WXUWAITPATH="/SYSTEM/tmp/c49677"                                                                       
  WLOGF=`ls /SYSTEM/var/logs/wxu5cell/wxu50p/*.CR.def.WXU5.WXU50.WXU50P | tail -n 1`                     
  WTMP=`cat ${WLOGF} | grep "SERVICE LEVEL" | cut -d " " -f9`                                            
  WVER=`echo ${WTMP} | cut -d "." -f4`                                                                   
  echo "Current Service level is 8.5.5."$WVER                                                            
}                                                                                                        
function changeVersion {                                                                                 
  sed 's/'${OLDVER}'/'${WVER}'/w '${WXUWAITPATH}'/wxwait85.msg.mod' wxwait85.msg > wxwait85.msg.mod      
  cat wxwait85.msg.mod                                                                                   
}                                                                                                        
function activate {                                                                                      
  mv $WXUWAITPATH/wxwait85.msg $WXUAITHPATH/wxwait85.msg.old                                             
  mv $WXUWAITPATH/wxwait85.msg.mod $WXUWAITPATH/wxwait85.msg                                             
}                                                                                                        
                                                                                                         
getOldVersion                                                                                            
getVersion                                                                                               
changeVersion                                                                                            
activate                                                                                                 
