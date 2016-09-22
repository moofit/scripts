#!/bin/sh

# DW - Amsys - 2016.09.14
# Will deploy do not show first run setting for Filezilla into the User's Library as required
# 

username="$3"
if [ -z "$username" ] || [[ "$username" == "root" ]]; then		# Checks if the variable is empty (user running script from Self Service)
     username=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
fi
echo "Logging in user: $username"

PathForDirectory="/Users/$username/.config/filezilla"
PathForFile="${PathForDirectory}/filezilla.xml"

mkdir -p "$PathForDirectory"

echo "<?xml version="1.0"?>" > "$PathForFile"
echo "<FileZilla3 version="3.21.0" platform="*nix">" >> "$PathForFile"
echo "	<Settings>" >> "$PathForFile"
echo "		<Setting name="Update Check">1</Setting>" >> "$PathForFile"
echo "		<Setting name="Update Check Interval">7</Setting>" >> "$PathForFile"
echo "		<Setting name="Last automatic update check">2019-08-31 13:19:22</Setting>" >> "$PathForFile"
echo "		<Setting name="Disable update check">0</Setting>" >> "$PathForFile"
echo "	</Settings>" >> "$PathForFile"
echo "</FileZilla3>" >> "$PathForFile"

chown -R "$username" "/Users/$username/.config"

exit 0
