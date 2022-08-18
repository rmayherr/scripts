#/bin/bash
msg(){
echo "Usage: $0 f cp # where $0-means this script-file"
}
if [[ $# -eq 0 ]]; then
    echo "Please give one manualpage that you want to see"
else
#[[ $# -lt 1 ]] && msg
# the fucntion opens the whanted man pages in the cormium-browser
# the browser holds the file while the file will be removed
# the function aspets for one parameter
    file="$HOME/man_${1}.txt" 
    # man $1 > $file     ==>UTF-8      
    man $1 | col -b > $file  # ASCII         
    wresult=`wc -c $file 2> /dev/null | awk '{print $1}'`
    if [ $wresult -le 1 ];then
	echo "Such page is not found in man.Try again."
	exit
    fi
    # opens the temporary.txt file in new or existing browser
    firefox $file
    sleep 2 # whait while the text appears in the browser
    rm $file # the file remains in the browsers tab
fi
