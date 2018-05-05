#!/bin/bash

# Author:   Stephen Bygrave - Moof IT
# Name:     shareConnect.sh
#
# Purpose:  Mounts a share on login
# Usage:    Script in Jamf Pro policy
#
# Version 1.0.0, 2018-04-17
#   Initial Creation

# Use at your own risk. moof IT will accept no responsibility for loss or damage
# caused by this script.

##### Set variables

logProcess="shareConnect"
userName="${3}"
protocol="${4}"
serverName="${5}"
shareName="${6}"

##### Declare functions

writelog ()
{
    /usr/bin/logger -is -t "${logProcess}" "${1}"
    if [[ -e "/var/log/jamf.log" ]];
    then
        /bin/echo "$(date +"%a %b %d %T") $(hostname -f | awk -F "." '{print $1}') jamf[${logProcess}]: ${1}" >> "/var/log/jamf.log"
    fi
}

echoVariables ()
{
    writelog "Log Process: ${logProcess}"
    writelog "User: ${userName}"
    writelog "Protocol: ${protocol}"
    writelog "Server: ${serverName}"
    writelog "Sharename: ${shareName}"
}

checkUsername ()
{
    # Checks if the username variable is empty (user running script from Self
    # Service)
    if [[ -z "${userName}" ]];
    then
        userName=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
    fi
}

mountShare ()
{
    mount_script=`/usr/bin/osascript > /dev/null << EOT
    # tell application "Finder"
    activate
    mount volume "${protocol}://${serverName}/${shareName}"
    # end tell
EOT`
    exitStatus="${?}"
}

##### Run script

echoVariables
checkUsername
mountShare

writelog "Script completed."
