This script can manually set the wallpaper in OS X.  It uses osascript to set the background immediately for users that are logged in, then uses sqlite3 to set the same value into the desktoppicture.db of any other home folders in /Users.

The only value you need to set will be the wallpaper variable at the top of the script.

Don't forget to deploy the actual wallpaper file to the target Macs first!
