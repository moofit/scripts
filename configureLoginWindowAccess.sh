#!/bin/bash

#########################################################################################
# Author:   Darren Wallace - Amsys
# Name:     configureLoginWindowAccess.sh
#
# Purpose:  This script will configure the login window to only allow users who 
#			are a member of the user group specified in line 33 to login. 
#			Please Note: This group needs to be accessable by the end device
#			E.g. if using an AD group, the device must be bound to AD before 
#			pushing this script out.
#			Optionally, it can also be used to also allow local admin users or 
#			all local users, by editing line 36.
#			"admin" will only add the specified group and the local 'admin' 
#			group. "all" will only add the specified group and all local users.
#
# Credit:   Thanks to Greg Neagle's post on JamfNation for the details on what was requried
#           https://www.jamf.com/jamf-nation/discussions/14476/automate-mobile-users-allowed-to-log-in-to-a-system-as-the-first-user-to-login-only#responseChild88282
#
# Usage:    CLI | Jamf Pro
#
# Version 2017.12.12 - DW - Initial Creation
#
#########################################################################################

##################################### Set variables #####################################

# Name of the script
scriptName="configureLoginWindowAccess.sh"
# Location of the LogFile to save output to
logFile="/Library/Logs/${scriptName}"
# Name of group that is allow to log into the Mac (AD, OD or Local)
allowGroup="AllowedMacUsers"
# Should local users also have access? 
# Acceptable Answers: "admin" "all" "no" (all lower case)
extraUsers="admin"

################################## Declare functions ####################################

# Function to write input to the terminal and a logfile
writeLog ()
{
	echo "$(date) - ${1}"
	echo "$(date) - ${1}" >> "${logFile}"
}

##################################### Run Script #######################################

	writeLog "Starting script: ${scriptName}"

# Create the two required groups to limit AD access at the login window
	writeLog "Creating the com.apple.loginwindow.netaccounts group"
	dscl . -create /Groups/com.apple.loginwindow.netaccounts
# Figure out the next free GID
	nextGID=$(dscl . -list /Groups PrimaryGroupID | awk 'BEGIN{i=0}{if($2>i)i=$2}END{print i+1}')
	dscl . -create /Groups/com.apple.loginwindow.netaccounts PrimaryGroupID "${nextGID}"
	writeLog "Creating the com.apple.access_loginwindow group"
	dscl . -create /Groups/com.apple.access_loginwindow
# Figure out the next free GID
	nextGID=$(dscl . -list /Groups PrimaryGroupID | awk 'BEGIN{i=0}{if($2>i)i=$2}END{print i+1}')
	dscl . -create /Groups/com.apple.access_loginwindow PrimaryGroupID "${nextGID}"

# Add the primary group ($allowGroup) to the 'allow' login list
	writeLog "Adding the primary group to the login allow list"
	dseditgroup -o edit -n /Local/Default -a "${allowGroup}" -t group com.apple.loginwindow.netaccounts

# Adding the netaccounts group to the access group
	writeLog "Adding the netaccounts group to the access group"
	dseditgroup -o edit -n /Local/Default -a com.apple.loginwindow.netaccounts -t group com.apple.access_loginwindow
	
# Check if there are additional groups to be added
	writeLog "Check if there are additional groups to be added"
	if [[ "${extraUsers}" == "admin" ]]; then
		writeLog "Adding the admin group to the access list"
		dseditgroup -o edit -n /Local/Default -a admin -t group com.apple.access_loginwindow
	elif [[ "${extraUsers}" == "all" ]]; then
		writeLog "Adding all local users group (localaccounts) to the access list"
		dseditgroup -o edit -n /Local/Default -a localaccounts -t group com.apple.access_loginwindow
	else
		writeLog "No additional users to add"
	fi

	writeLog "Script Complete"

	exit

##################################### End Script #######################################
