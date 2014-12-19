#!/bin/sh

wallpaper="/Library/Desktop Pictures/your_picture.jpg"

# Set the wallpaper imediately for logged in users
osascript -e 'tell application "Finder" to set desktop picture to POSIX file "$wallpaper"'

# Then set it for any other users that aren't logged in yet
for USER_HOME in /Users/*
	do
		USER_UID=`basename "${USER_HOME}"`
		if [ ! "${USER_UID}" = "Shared" ] 
		then 
		if [ -d "${USER_HOME}"/Library/Application\ Support ]
		then
			/usr/bin/sqlite3 "${USER_HOME}"/Library/Application\ Support/Dock/desktoppicture.db "update data set value = '$wallpaper'"
		fi
	fi
	done

exit 0