#!/bin/bash

#########################################################################################
# NAME:			Change Outlook Exchnage email domains - BASH							#
# VERSION:		2016.06.13																#	
# HISTORY:		v2016.06.13 - DW - Amsys - Initial Creation								#
# 																						#
# DESCRIPTION:	Loop through the first 3 'exchange' type accounts, looking for "BADDOMAIN.COM" in both the	#
#				username and email address fields. If found, change the domain to "GOODDOMAIN.COM".			#
#																						#
# AUTHOR:		DW (AMSYS)																#
#																						#
# DISCLAIMER:	Use at your own risk.  Amsys will accept no responsibility for loss	 	#
#				or damage caused by this script.										#
#																						#
# USAGE:		1) Run a 'find and replace' on this script, replacing "BADDOMAIN.COM" with the exact domain	#
#					you are looking to swap OUT.										#
#				2) Run a 'find and replace' on this script, replacing "GOODDOMAIN.COM" with the exact domain #
#					you are looking to swap IN.											#
#				3) Run this script on the client device									#
#																						#
#########################################################################################

# Old: BADDOMAIN.COM
# New: GOODDOMAIN.COM

username="$3"
    if [ -z "$username" ]; then		# Checks if the variable is empty (user running script from Self Service)
        username=$( python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");' )
    fi
echo "User: $username"

su "${3}" -c osascript <<'END'
tell application "Microsoft Outlook"
	try
		set emailAddress to email address of exchange account 1
		set username to user name of exchange account 1
		if ((emailAddress as string) contains "BADDOMAIN.COM") then
			set emailname to (do shell script "echo  " & quoted form of text 1 through -2 of emailAddress & " | awk -F \"@\" '{print $1}' $1")
			set email address of exchange account 1 to emailname & "@GOODDOMAIN.COM"
			if ((username as string) contains "BADDOMAIN.COM") then
				set emailname to (do shell script "echo  " & quoted form of text 1 through -2 of username & " | awk -F \"@\" '{print $1}' $1")
				set user name of exchange account 1 to emailname & "@GOODDOMAIN.COM"
			end if
		end if
		set emailAddress to email address of exchange account 2
		set username to user name of exchange account 2
		if ((emailAddress as string) contains "BADDOMAIN.COM") then
			set emailname to (do shell script "echo  " & quoted form of text 1 through -2 of emailAddress & " | awk -F \"@\" '{print $1}' $1")
			set email address of exchange account 2 to emailname & "@GOODDOMAIN.COM"
			if ((username as string) contains "tonyblairfaithfoundation.org") then
				set emailname to (do shell script "echo  " & quoted form of text 1 through -2 of username & " | awk -F \"@\" '{print $1}' $1")
				set user name of exchange account 2 to emailname & "@GOODDOMAIN.COM"
			end if
		end if
		set emailAddress to email address of exchange account 3
		set username to user name of exchange account 3
		if ((emailAddress as string) contains "BADDOMAIN.COM") then
			set emailname to (do shell script "echo  " & quoted form of text 1 through -2 of emailAddress & " | awk -F \"@\" '{print $1}' $1")
			set email address of exchange account 3 to emailname & "@GOODDOMAIN.COM"
			if ((username as string) contains "tonyblairfaithfoundation.org") then
				set emailname to (do shell script "echo  " & quoted form of text 1 through -2 of username & " | awk -F \"@\" '{print $1}' $1")
				set user name of exchange account 3 to emailname & "@GOODDOMAIN.COM"
			end if
		end if
	end try
end tell

END



