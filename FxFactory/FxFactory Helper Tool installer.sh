#!/bin/bash

#########################################################################################
# Author:   Darren Wallace - Amsys
# Name:     FxFactory - Helper Tool installer
#
# Purpose:  This script will complete the helper tool installation to stop the first run
#			admin authentication request
# Usage:    Jamf Pro
#
# Version 2017.07.04 - DW - Initial Creation
#
#########################################################################################
#
# Copyright (c) 2017, Amsys Ltd.  All rights reserved.
#
#       Redistribution and use in source and binary forms, with or without
#       modification, are permitted provided that the following conditions are met:
#               * Redistributions of source code must retain the above copyright
#                 notice, this list of conditions and the following disclaimer.
#               * Redistributions in binary form must reproduce the above copyright
#                 notice, this list of conditions and the following disclaimer in the
#                 documentation and/or other materials provided with the distribution.
#               * Neither Amsys Ltd nor the
#                 names of its contributors may be used to endorse or promote products
#                 derived from this software without specific prior written permission.
#
#       THIS SOFTWARE IS PROVIDED BY Amsys LTD "AS IS" AND ANY
#       EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#       WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#       DISCLAIMED. IN NO EVENT SHALL Amsys LTD BE LIABLE FOR ANY
#       DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#       (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#       LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#       ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#       (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#       SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#########################################################################################
#
# SUPPORT FOR THIS PROGRAM
#
#       This program is distributed "as is" by Amsys LTD.
#       For more information or support, please utilise the following resources:
#
#               http://www.amsys.co.uk
#
#########################################################################################

##################################### Set variables #####################################

# Name of the script
scriptName="FxFactory - Helper Tool installer"
# Location of the LogFile to save output to
logFile="/Library/Logs/${scriptName}"
# Helper Directory
helperDir="/Library/PrivilegedHelperTools"
# Helper tool source location
helperSource="/Applications/FxFactory.app/Contents/Library/LaunchServices/com.fxfactory.FxFactory.helper"
# Helper tool destination location
helperDest="${helperDir}/com.fxfactory.FxFactory.helper"
# Launch Daemon for the Helper Tool
helperLaunchDaemon="/Library/LaunchDaemons/com.fxfactory.FxFactory.helper.plist" 


################################## Declare functions ####################################

echoVariables ()
{
    echo "${}"
}

# Function to write input to the terminal and a logfile
writelog ()
{
	echo "$(date) - ${1}"
	echo "$(date) - ${1}" >> "${logFile}"
}

# Function to check and create Helper Tool Directory
checkHelperDir ()
{
	if [[ -d "${helperDir}" ]]; 
	then
		writelog "Helper Directory present at ${helperDir}"
	else
		mkdir "${helperDir}"
		chown root:wheel "${helperDir}"
		chmod 755 "${helperDir}"
		writelog "Helper Directory NOT present but created at ${helperDir}"
	fi
}

# Function to copy over and permission Helper Tool
copyHelperTool ()
{
	/bin/cp -f "${helperSource}" "${helperDest}"
	/usr/sbin/chown root:wheel "${helperDest}"
	/bin/chmod 544 "${helperDest}"
	writelog "Helper Tool copied over to ${helperDest}"
}

# Create Launch Daemon for the helper tool
createLaunchDaemon ()
{
	rm "${helperLaunchDaemon}"
	/usr/libexec/PlistBuddy -c "Add Label string" "${helperLaunchDaemon}"
	/usr/libexec/PlistBuddy -c "Set Label com.fxfactory.FxFactory.helper" "${helperLaunchDaemon}"
 	/usr/libexec/PlistBuddy -c "Add MachServices dict" "${helperLaunchDaemon}"
	/usr/libexec/PlistBuddy -c "Add MachServices:com.fxfactory.FxFactory.helper bool" "${helperLaunchDaemon}"
	/usr/libexec/PlistBuddy -c "Set MachServices:com.fxfactory.FxFactory.helper true" "${helperLaunchDaemon}"
 	/usr/libexec/PlistBuddy -c "Add ProgramArguments array" "${helperLaunchDaemon}"
	/usr/libexec/PlistBuddy -c "Add ProgramArguments:0 string" "${helperLaunchDaemon}"
	/usr/libexec/PlistBuddy -c "Set ProgramArguments:0 ${helperDest}" "${helperLaunchDaemon}"
 	/bin/launchctl load "${helperLaunchDaemon}"
 	writelog "LaunchDaemon created and loaded at ${helperLaunchDaemon}"
 }

##################################### Debug Setup #######################################

# If running natively as a script, Add "-d or --debug" at run time to enable
# debugging messages. If running from Casper, set the variable $9 to "Yes".
if [[ "${1}" == --debug || "${1}" == -d || "${9}" == [Yy] || "${9}" == [Yy]es ]];
then
    echo ""
    echo "##### Using Debug mode"
    echo ""
    set +x
    debug=1
fi

### Debug Setup
if [[ ${debug} -eq 1 ]];
then
    echoVariables
fi

##################################### Run Script #######################################

# Check and create Helper Tool Directory if required
checkHelperDir
# Copy over and permission Helper Tool
copyHelperTool
# Create and load Launch Daemon
createLaunchDaemon

exit