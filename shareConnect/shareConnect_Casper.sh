#!/bin/bash

# Created by David Acland - Amsys
#
# Use at your own risk.  Amsys will accept
# no responsibility for loss or damage
# caused by this script.

username="$3"
    if [ -z "$username" ]; then		# Checks if the variable is empty (user running script from Self Service)
        username="$USER"
    fi
    echo "User: $username"
protocol="$4"	# This is the protocol to connect with (afp | smb)
    echo "Protocol: $4"
serverName="$5"	# This is the address of the server, e.g. my.fileserver.com
    echo "Server: $5"
shareName="$6"	# This is the name of the share to mount
    echo "Sharename: $6"
		
# Mount the drive
	mount_script=`/usr/bin/osascript > /dev/null << EOT
	tell application "Finder" 
	activate
	mount volume "$protocol://${serverName}/${shareName}"
	end tell
EOT`

exit 0
