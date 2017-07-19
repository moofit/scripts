#!/bin/bash

# Created by Amsys
#
# Use at your own risk.  Amsys will accept
# no responsibility for loss or damage
# caused by this script.

##### ADVANCED MODIFICATION ONY BELOW THIS LINE #####

# Create a log writing function
writelog()
{
	echo "${1}"	
}

writelog "STARTING: User drive mount"

# Already mounted check

# The following checks confirm whether the user's personal network drive is already mounted,
# (exiting if it is).  If it is not already mounted, it checks if there is a mount point
# already in /Volumes.  If there is, it is deleted.

isMounted=`mount | grep -c "/Volumes/$USER"`

if [ $isMounted -ne 0 ] ; then
	writelog "Network share already mounted for $USER"
	exit 0
fi

# Mount network home
writelog "Retrieving SMBHome attribute for $USER"

# Get Domain from full structure, cut the name and remove space.
ShortDomainName=`dscl /Active\ Directory/ -read . | grep SubNodes | sed 's|SubNodes: ||g'`

# Find the user's SMBHome attribue, strip the leading \\ and swap the remaining \ in the path to /
# The result is to turn smbhome: \\server.domain.com\path\to\home into server.domain.com/path/to/home
adHome=$(dscl /Active\ Directory/$ShortDomainName/All\ Domains -read /Users/$USER SMBHome)
if [ $? -ne 0 ]
then
	writelog "ERROR: Cannot read ${USER}'s SMBHome attribute from '/Active Directory/$ShortDomainName/All Domains'.  Exiting script."
	exit 1
else
  adHome=$(echo "${adHome}" | sed 's|SMBHome:||g' | sed 's/^[\\]*//' | sed 's:\\:/:g' | sed 's/ \/\///g' | tr -d '\n' | sed 's/ /%20/g')
fi

# Next we perform a quick check to make sure that the SMBHome attribute is populated
case "$adHome" in 
 "" ) 
	writelog "ERROR: ${USER}'s SMBHome attribute does not have a value set.  Exiting script."
	exit 1  ;;
 * ) 
	writelog "Active Directory users SMBHome attribute identified as $adHome"
	;;
esac

# Mount the network home
	mount_script=`/usr/bin/osascript > /dev/null << EOT
#	tell application "Finder" 
#	activate
	mount volume "smb://${adHome}"
#	end tell
EOT`

writelog "Script completed"
# Script End

exit 0