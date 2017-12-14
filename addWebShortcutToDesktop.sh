#!/bin/bash

#########################################################################################
# Author:   Darren Wallace - Amsys
# Name:     addWebShortcutToDesktop.sh
#
# Purpose:  This script will add a Web Shortcut (weblock) file to the currently 
#			logged in user's desktop. 
#			The URL used can be specified on line 24, and the name of the file 
#			can be specified in line 22. 
#			The script will bail out if it detects 'root' or blank as the logged
#			in user.
# Usage:    CLI | Jamf Pro
#
# Version 2017.12.14 - DW - Initial Creation
#
#########################################################################################

##################################### Set variables #####################################

# Name you wish the shortcut (weblock) file to have
webLockFileName="Apple Support Pages"
# URL you want the shortcut to point to
webLockDestination="https://www.apple.com/support"

# Name of the script
scriptName="addWebShortcutToDesktop.sh"
# Location of the LogFile to save output to
logFile="/Library/Logs/${scriptName}"
# Work out the currently logged in user
loggedInUser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
# Work out the final destination for the file
# This next line works out the user's home, even if working direct from a network volume (yuk)
eval usersNetworkHome="~${loggedInUser}"
finalLocation="${usersNetworkHome}/Desktop/${webLockFileName}.webloc"

################################## Declare functions ####################################

# Function to write input to the terminal and a logfile
writeLog ()
{
	/bin/echo "$(date) - ${1}"
	/bin/echo "$(date) - ${1}" >> "${logFile}"
}

##################################### Run Script #######################################

	writeLog "Starting script: ${scriptName}"

# Check if the current user is 'root' or blank	
	if [[ "${loggedInUser}" == "root" ]]; then
# Current user detected as root so we will exit
		writeLog "Current user detected as 'root', bailing out..."
		exit 0
	elif [[ "${loggedInUser}" == "" ]]; then
# Current user detected as blank so we will exit
		writeLog "Current user detected as blank, bailing out..."
		exit 0
	fi

# Current user detected correctly, so off we go
	writeLog "Saving shortcut to: ${finalLocation}"

# Create Web lock file
	/bin/echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>URL</key>
    <string>${webLockDestination}</string>
</dict>
</plist>" > "${finalLocation}"

# Permission the file correctly
	/usr/sbin/chown "${loggedInUser}" "${finalLocation}"

##################################### End Script #######################################
