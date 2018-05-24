#!/bin/bash

# Author:   Stephen Bygrave - Moof IT
# Name:     removeProfile.sh
#
# Purpose:  Will remove a (or many) profile(s) from a Mac
# Usage:    Run in Terminal
#
# Version 1.0.0, 2018-05-24
#   SB - Initial Creation

# Use at your own risk. Moof IT will accept no responsibility for loss or damage
# caused by this script.

##### Set variables

logProcess="removeProfile"
profileName="MDM Profile"

##### Declare functions

writelog ()
{
    /usr/bin/logger -is -t "${logProcess}" "${1}"
}

echoVariables ()
{
    writelog "Log Process is ${logProcess}"
}

##### Run script

echoVariables

# Get UUID of requested MDM Profile
mdmID=$(/usr/bin/profiles -Lv | grep "name: ${profileName}" -4 | awk -F": " '/attribute: profileIdentifier/{print $NF}')

# Remove said profile, identified by UUID
if [[ $"{mdmID}" ]];
then
    /usr/bin/profiles -R -p "${mdmID}"
else
    echo "No Profile Found"
fi

writelog "Script completed."
