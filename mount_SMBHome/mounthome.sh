#!/bin/bash

# Created by Amsys
#
# Use at your own risk.  Amsys will accept
# no responsibility for loss or damage
# caused by this script.

# Set variables
mount_protocol=`smb`
logfile="/Library/Logs/mountHome.log"


##### ADVANCED MODIFICATION ONY BELOW THIS LINE #####

# Create a log writing function
writelog()
{
	# writes to $logfile
	echo $(date) "${1}" >> $logfile
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

if [ -d /Volumes/$USER ] ; then
	writelog "/Volumes/$username already exists, removing..."
	rm -R /Volumes/$USER
fi

# Mount network home
writelog "Retrieving SMBHome attribute for $USER"

# Get Domain from full structure, cut the name and remove space.
ShortDomainName=`dscl /Active\ Directory/ -read . | grep SubNodes | sed 's|SubNodes: ||g'`

# Find the user's SMBHome attribue, strip the leading \\ and swap the remaining \ in the path to /
# The result is to turn smbhome: \\server.domain.com\path\to\home into server.domain.com/path/to/home
adHome=$(dscl /Active\ Directory/$ShortDomainName/All\ Domains -read /Users/$USER SMBHome | sed 's|SMBHome:||g' | sed 's/^[\\]*//' | sed 's:\\:/:g' | sed 's/ \/\///g' | tr -d '\n' | sed 's/ /%20/g')

# Next we perform a quick check to make sure that the SMBHome attribute is populated
case "$adHome" in 
 "" ) 
	writelog "ERROR: ${USER}'s SMBHome attribute does not have a value set.  Exiting script."
	exit 1  ;;
 * ) 
	writelog "Active Directory users SMBHome attribute identified as $adHome"
	;;
esac

# Create the mount point on the client computer
mkdir /Volumes/$USER/

# Error checking starts below this line
if [ $? -ne 0 ]
    then
       	writelog "ERROR: Failed to create local mount point /Volumes/$USER"
       	rm -r /Volumes/$USER
        exit 3;
    else
		writelog "Local mount point successfully created /Volumes/$USER"
		fi
fi
# Error checking completed

# If it is afp do this…..
if [ $mount_protocol = "afp" ] ; then
	writelog "Mount protocol identified as $mount_protocol"
	
	# Mount the users home using AFP
	afpMount=`mount_afp "afp://;AUTH=Client%20Krb%20v2@$adHome" /Volumes/$USER`
	
	# Error checking starts below this line
		if [ $? -ne 0 ]
		then
         	writelog "ERROR: Failed to mount users home directory"
        	rm -r /Volumes/$username
	    exit 4;
        else
			writelog "Users home directory mounted successfully"
		fi
	# Error checking completed
	else

	# If it is smb do this…..	
	if [ $mount_protocol = "smb" ] ; then
		writelog "Mount protocol identified as $mount_protocol"
				
		# Mount the users home using SMB
		smbMount=`mount -t smbfs //$adHome /Volumes/$USER`
			
		# Error checking starts below this line
			if [ $? -ne 0 ]
			then
	         	writelog "ERROR: Failed to mount users home directory"
	        	rm -r /Volumes/$USER
	       	exit 5;
	       	else
				writelog "Users home directory mounted successfully"
			fi
		# Error checking completed
	fi
fi	

writelog "Script completed"
# Script End

exit 0