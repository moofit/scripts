This script can be used to delete local keychains for the logged in user.

This is generally used in education settings where the Macs are shared devices.  Setting this script to run at logout ensures that the user won't get keychain errors when they login, if they have changed their password elsewhere.

We would recommend setting to run at logout via a logout hook, or by using your mac management system:

defaults write com.apple.loginwindow LogoutHook /path/to/script.sh
