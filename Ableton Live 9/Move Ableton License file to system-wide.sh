#!/bin/sh

app_Location="/Applications/Ableton Live 9 Standard.app"

username="$3"
    if [ -z "$username" ]; then		# Checks if the variable is empty (user running script from Self Service)
        username="$USER"
    fi
license_File_Source="/Users/${username}/Library/Application Support/Ableton/Live 9.5/Unlock/Unlock.cfg"
license_File_Destination="/Library/Application Support/Ableton/Live 9.5/Unlock/"

#################################

cp -R "${license_File_Source}" "${license_File_Destination}"

chown -R root:admin "${license_File_Destination}"
chmod -R 755 "${license_File_Destination}"

exit 0


