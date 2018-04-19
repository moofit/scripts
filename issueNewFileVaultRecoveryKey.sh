#!/bin/bash

# Author:   Stephen Bygrave - moof IT
# Name:     issueNewFileVaultRecoveryKey.sh
#
# Purpose:  This script changes the recovery key for the current logged in user
# Usage:    Jamf Pro policy
#
# Version 1.0.0, 2017-12-30
#   SB - Initial Creation
# Version 1.1.0, 2018-04-18
#   SB - Changes to AppleScript and cosmetics
# Version 1.1.1, 2018-04-19
#   SB - Changes to error reporting

# Use at your own risk.  Amsys will accept no responsibility for loss or damage
# caused by this script.

##### Set variables

logProcess="issueNewFileVaultRecoveryKey"
userName=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
userNameUUID=$(dscl . -read /Users/${userName}/ GeneratedUID | awk '{print $2}')
OS=`/usr/bin/sw_vers -productVersion | awk -F. {'print $2'}`
userCheck=`/usr/bin/fdesetup list | awk -v usrN="$userNameUUID" -F, 'match($0, usrN) {print $1}'`

##### Declare functions

writelog ()
{
    /usr/bin/logger -is -t "${logProcess}" "${1}"
    if [[ -e "/var/log/jamf.log" ]];
    then
        echo "$(date +"%a %b %d %T") $(hostname -f | awk -F "." '{print $1}') jamf[${logProcess}]: ${1}" >> "/var/log/jamf.log"
    fi
}

echoVariables ()
{
    writelog "Log Process is ${logProcess}"
    writelog "User is ${userName}"
    writelog "UUID is ${userNameUUID}"
    writelog "OS is ${OS}"
}

checkForFV ()
{
    ## This first user check sees if the logged in account is already authorized with FileVault 2
    if [[ "${userCheck}" != "${userName}" ]];
    then
    	writelog "This user is not a FileVault enabled user."
    	exit 3
    else
        writelog "User is enabled for FileVault. Continuing..."
    fi
}

checkForFVComplete ()
{
    ## Check to see if the encryption process is complete
    encryptCheck=$(/usr/bin/fdesetup status)
    statusCheck=$(echo "${encryptCheck}" | grep "FileVault is On.")
    expectedStatus="FileVault is On."
    if [[ "${statusCheck}" != "${expectedStatus}" ]];
    then
    	writelog "The encryption process has not completed: ${encryptCheck}"
    	exit 4
    fi
}

grabUserPass ()
{
    ## Get the logged in user's password via a prompt
    writelog "Prompting ${userName} for their login password."
    userPass=$(/usr/bin/osascript -e "set myUserPass to text returned of (display dialog \"Your FileVault key is invalid. Please enter your login password to create a new one:\" default answer \"\" with title \"Login Password\" buttons {\"OK\"} default button 1 with hidden answer)")
}

issueRecoveryKey ()
{
    writelog "Issuing new recovery key"

    if [[ "${OS}" -ge 9 ]];
    then
    	## This "expect" block will populate answers for the fdesetup prompts that normally occur while hiding them from output
    	fvKeyRotateStatus=$(expect -c "
    	log_user 0
    	spawn /usr/bin/fdesetup changerecovery -personal
    	expect \"Enter the user name:\"
    	send {${userName}}
    	send \r
    	expect \"Enter the password for user {${userName}}:\"
    	send {${userPass}}
    	send \r
    	log_user 1
    	expect eof
    	")
    	if [[ "${fvKeyRotateStatus}" =~ .*New\ personal\ recovery\ key.* ]]
    	then
    	    writelog "FileVault recovery key rotated successfully."
    	else
    	    writelog "Unable to rotate FileVault recovery key, error: ${fvKeyRotateStatus}"
    	fi
    else
    	writelog "OS version not 10.9+ or OS version unrecognized: $(/usr/bin/sw_vers -productVersion)"
    	exit 5
    fi
    sleep 60
    /usr/local/bin/jamf recon
}

##### Run script
echoVariables
checkForFV
checkForFVComplete
grabUserPass
issueRecoveryKey

writelog "Script completed."
