#!/bin/sh

# DW - Amsys - 2016.09.14
# Will use Duti to set the default PDF handler to Acrobat Pro
# 

PathToDuti="/usr/local/bin/duti"

##### ADVANCED MODIFICATION ONY BELOW THIS LINE #####

# Create a log writing function
writelog()
{
	echo "${1}"	
}

writelog "STARTING: Set PDF viewer"

username="$3"
if [ -z "$username" ]; then		# Checks if the variable is empty (user running script from Self Service)
    USERNAME=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
fi
    
if [[ -e "${PathToDuti}" ]]; then
    echo "Duri binary found"
    su "${username}" -c "${PathToDuti} -s com.adobe.Acrobat.Pro pdf all"
else
    echo "Duti binary not installed at ${PathToDuti}, skipped"
fi  

exit 0    

    
