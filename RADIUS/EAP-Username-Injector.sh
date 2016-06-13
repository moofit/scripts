#!/bin/bash

#########################################################################################
# NAME:			EAP-Username-Injector													#
# VERSION:		2016.06.10																#	
# HISTORY:		v2016.06.10 - DW - Amsys - Initial Creation								#
# 																						#
# DESCRIPTION:	Inject the local computer's fully-qualified hostname into the EAP 		#
#				profile, in place of "CHANGEME". Once complete, import the profile 		#
#				into the local Computer.												#
#																						#
# AUTHOR:		DW (AMSYS)																#
#																						#
# DISCLAIMER:	Use at your own risk.  Amsys will accept no responsibility for loss	 	#
#				or damage caused by this script.										#
#																						#
# USAGE:		1) Build a typical unsigned RADIUS profile and download.				#
#				2) Edit the "Username" tag in the 'EAP' section to be:					#
#					"host/CHANGEME"														#
#				3) Edit line 31 below to match the name of the profile you've created	#
#				4) Build a package to deploy your profile into /private/tmp/			#
#				5) Add this script as a post-flight/-install script						#
#				6) Deploy this out to booted devices.									#
#				7) This MUST run on a 'postponed install' (DeployStudio)				#
#					or set as 'Install on boot drive after imaging' (Casper)			#											
#																						#
##########################################################################################

#################################### Variables ###########################################
# Path and name of the Profile to work on (must be on the local file system)
	PathToTemplateProfile="/private/tmp/RADIUS template.mobileconfig"
	
##########################################################################################
########################### Do not edit below this line ##################################
##########################################################################################

# Phrase to look for and replace in the profile with the fully-qualified hostname
	PhraseToReplace="CHANGEME"
	
# Location of the LogFile to save output to
	LogFile="/Library/Logs/EAP-Username-Injector.log"
	
# Placeholder for the fully-qualified hostname variable.
	# DO NOT ALTER
	FullyQualifiedHostname=""
	
#################################### Functions ###########################################

# Function to write input to the terminal and a logfile
writelog()
{
	echo "$(date) - ${1}"
	echo "$(date) - ${1}" >> "${LogFile}"
}

# Function to check for the presence of the profile to work on, and error out if not
CheckForProfile ()
{
	if [[ -a "${PathToTemplateProfile}" ]]; then
		writelog "Template Profile Found at: ${PathToTemplateProfile}"
	else
		writelog "Template Profile NOT Found at: ${PathToTemplateProfile}"
		writelog "FAILURE - Template Profile Not Found"
		writelog "Exit code 2"
		exit 2 
	fi
}

# Function to get the fully-qualified hostname
GetFQHostname ()
{
	FullyQualifiedHostname="$(host $(hostname) | awk '{print $1}')"
	writelog "Fully Qualified Hostname detected as: ${FullyQualifiedHostname}"
}

# Function to validate the FQ Hostname is a FQ hostname
ValidateFQHostname ()
{
	if [[ "${FullyQualifiedHostname}" == *"."* ]]; then
		writelog "Fully Qualified Hostname verified successfully"
	else
		writelog "Fully Qualified Hostname NOT verified successfully"
		writelog "FAILURE - Fully Qualified Hostname not detected correctly"
		writelog "Exit code 3"
		exit 3
	fi		
}

# Function to inject the FQ host into the Profile
InjectFQHostname ()
{
	sed -i '' -e 's/'"${PhraseToReplace}"'/'"${FullyQualifiedHostname}"'/' "${PathToTemplateProfile}"
	exitcode="${?}"
	if [[ "${exitcode}" != 0 ]]; then
		writelog "Failed to inject the Fully Qualified hostname into the profile with sed exit code ${exitcode}"
		writelog "FAILURE - Failed to inject the hostname into the profile"
		writelog "Exit code 4"
		exit 4
	else
		writelog "Successfully injected the Fully Qualified hostname into the profile"
	fi
}

# Function to install the profile into the local OS.
InstallProfile ()
{
    /usr/bin/profiles -I -F "${PathToTemplateProfile}" ''
    exitcode="${?}"
    if [[ "${exitcode}" != 0 ]]; then
    	writelog "Profile failed to install with profiles exit code ${exitcode}"
    	writelog "FAILURE - Failed to install the profile"
    	writelog "Exit code 5"
    	exit 5
    else
    	writelog "Profile installed successfully"
    fi
}

# Function to clear out profile file after installing
RemoveProfileFile ()
{
	if [[ -a "${PathToTemplateProfile}" ]]; then
		rm -R "${PathToTemplateProfile}"
		writelog "Template Profile File removed"
	fi
}

##########################################################################################
########################### Script Start #################################################
##########################################################################################

writelog " - - - - - - - - - - - - - - - - - - - "
writelog "Starting EAP-Username-Injector script - "

# Check for Profile file
	CheckForProfile
# Check the local machine's fully qualified hostname
	GetFQHostname
# Ensure the obtained fully qualified hostname has at least one '.'
	ValidateFQHostname
# Add that fully qualified hostname into the profile in place of the 'PhraseToReplace'
	InjectFQHostname
# Install the worked on template profile
	InstallProfile
# From the unrequired profile file
	RemoveProfileFile

writelog "EAP-Username-Injector script complete - "
writelog " - - - - - - - - - - - - - - - - - - - "

##########################################################################################
########################### Script End ###################################################
##########################################################################################
