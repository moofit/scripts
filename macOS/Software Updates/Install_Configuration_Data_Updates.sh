#!/bin/bash

#########################################################################################
# Author:   Darren Wallace - Amsys
# Name:     Install_Configuration_Data_Updates.sh
#
# Purpose:  This script uses the undocumented '--include-config-data' flag for 
#			softwareupdate to list and run these updates.
#			This includes data for Apple's GateKeeper, X Protect and Malware 
#			Removal Tool
#			*NOTE*: This only works on 10.12.x or newer.
#			*NOTE 2: This has only been tested on 10.12.6 (16G29) and 10.11.x
# Usage:    CLI
#
# Version 2018.01.22 - DW - Typo fix, minor pruning and switch to Moof IT!
# 		  2017.09.11 - DW - Initial Creation
#
#########################################################################################
#
# Copyright (c) 2018, Moof IT Ltd.  All rights reserved.
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
#               http://www.moof-it.co.uk
#
#########################################################################################

##################################### Set variables #####################################

# Name of the script
scriptName="Install_Configuration_Data_Updates"

# Location of the LogFile to save output to
logFile="/Library/Logs/${scriptName}.log"

################################## Declare functions ####################################

# Function to write input to the terminal and a logfile
writeLog ()
{
	echo "$(date) - ${1}"
	echo "$(date) - ${1}" >> "${logFile}"
}

# Function to check the OS is 10.12.x or newer
checkOS ()
{
	writeLog "Checking OS Version..."
	osvers=$(sw_vers -productVersion | awk -F. '{print $2}')
	if [[ ${osvers} -ge 12 ]]; 
	then
		writeLog "OS Version is 10.12 or newer, proceeding..."
	else
		writeLog "OS Version is 10.11 or older and this script will not work."
		exit 0
	fi
}

# Function to check and list all avalible config data updates
checkForConfigData ()
{
	writeLog "Checking for Config Data updates"
	updatesFound=$(softwareupdate -l --include-config-data | awk '/\*/ && /ConfigData/' | sed 's/* //')
	if [ -z "${updatesFound}" ] || [[ "${updatesFound}" == "" ]];
	then
		writeLog "No Config Data updates available."
		exit 0
	else
		writeLog "Config Data updates found:"
		writeLog "${updatesFound}"
	fi
}

# Function to install all avalible config data updates
installConfigData ()
{
	writeLog "Installing available Config Data updates..."
	updatesToInstall="${updatesFound} | tr -d '\n'"
	softwareupdate -i ${updatesFound} --include-config-data
	exitCode="${?}"
	if [[ "${exitCode}" != 0 ]];
	then
		writeLog "ERROR: Error installing updates"
		writeLog "softwareupdate command error code ${?}"
		exit "${?}"
	else
		writeLog "Updates installed!"
		exit 0
	fi
}

##################################### Run Script #######################################

# Check the running OS to ensure it's at least 10.12 or newer
checkOS
# Run the undocumented flag for softwareupdate and parse the output
checkForConfigData
# Same as above, except this time we'll install using it
installConfigData

writeLog "ERROR: Unexpected script exit"
exit 2