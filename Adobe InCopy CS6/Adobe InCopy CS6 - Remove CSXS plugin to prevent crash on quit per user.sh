#!/bin/sh

# DW - Amsys - 2016.09.14
# Uses the Extension Manager CS6 app to remove the CSXS extension per user
# 

username="$3"
if [ -z "$username" ] || [[ "$username" == "root" ]]; then		# Checks if the variable is empty (user running script from Self Service)
     username=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
fi
echo "Logging in user: $username"

if [ -z "$username" ] || [[ "$username" == "root" ]] || [[ "$username" == "" ]]; then	
    echo "Username not correctly detected, exiting...."
    exit 1
fi

PathForBinary="/Applications/Adobe\ Extension\ Manager\ CS6/Adobe\ Extension\ Manager\ CS6.app/Contents/MacOS/Adobe\ Extension\ Manager\ CS6"

if [[ -a "${PathForBinary}" ]]; then
    su "${username}" -c "${PathForBinary} -suppress -remove product="InCopy CS6" extension="CSXS""
else
    echo "Binary not found, exiting..."
    exit 0
fi

exit 0
