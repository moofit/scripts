#!/bin/bash

# Author:   Stephen Bygrave - Moof IT
# Name:     disableJavaAutoUpdates.sh
#
# Purpose:  Checks to see the status of the Java AutoUpdater, and disables if
#           necessary.
# Usage:    Can be run as a ongoing login policy in Jamf, as this will remediate
#           automatically when a user logs in, if the updater is enabled.
#
# Version 1.0.0, 2018-05-05
#   SB - Initial Creation

# Use at your own risk. Moof IT will accept no responsibility for loss or damage
# caused by this script.

##### Set variables

logProcess="disableJavaAutoUpdates"

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
    writelog "Log Process is ${logProcess}"
}

checkJavaPreferences ()
{
    if [[ -e /Library/Preferences/com.oracle.java.Java-Updater.plist ]];
    then
        writelog "Java AutoUpdate preference file found."
    else
        writelog "Java AutoUpdate preference file not found. Java may not be installed. Exiting..."
        exit 1
    fi
}

disableAutoUpdate ()
{
    /usr/bin/defaults write /Library/Preferences/com.oracle.java.Java-Updater JavaAutoUpdateEnabled -bool false
    if [[ $? -eq 0 ]];
    then
        writelog "Java AutoUpdate disabled."
    else
        writelog "Unable to disable Java AutoUpdate. Bailing..."
        exit 1
    fi
}

##### Run script

echoVariables
checkJavaPreferences
disableAutoUpdate

writelog "Script completed."
