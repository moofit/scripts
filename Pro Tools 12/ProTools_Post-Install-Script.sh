#!/bin/bash
 
# Copy the com.avid.bsd.ShoeTool Helper Tool
PHT_SHOETOOL="/Library/PrivilegedHelperTools/com.avid.bsd.shoetoolv120"
 
/bin/cp -f "/Applications/Pro Tools.app/Contents/Library/LaunchServices/com.avid.bsd.shoetoolv120" $PHT_SHOETOOL
/usr/sbin/chown root:wheel $PHT_SHOETOOL
/bin/chmod 544 $PHT_SHOETOOL
 
# Create the Launch Deamon Plist for com.avid.bsd.ShoeTool
PLIST="/Library/LaunchDaemons/com.avid.bsd.shoetoolv120.plist"
FULL_PATH="/Library/PrivilegedHelperTools/com.avid.bsd.shoetoolv120"
 
rm $PLIST # Make sure we are idempotent
 
/usr/libexec/PlistBuddy -c "Add Label string" $PLIST
/usr/libexec/PlistBuddy -c "Set Label com.avid.bsd.shoetoolv120" $PLIST
 
/usr/libexec/PlistBuddy -c "Add MachServices dict" $PLIST
/usr/libexec/PlistBuddy -c "Add MachServices:com.avid.bsd.shoetoolv120 bool" $PLIST
/usr/libexec/PlistBuddy -c "Set MachServices:com.avid.bsd.shoetoolv120 true" $PLIST
 
/usr/libexec/PlistBuddy -c "Add ProgramArguments array" $PLIST
/usr/libexec/PlistBuddy -c "Add ProgramArguments:0 string" $PLIST
/usr/libexec/PlistBuddy -c "Set ProgramArguments:0 $FULL_PATH" $PLIST
 
/bin/launchctl load $PLIST

mkdir -p "/Library/Application Support/Avid/Audio/Plug-Ins"
mkdir -p "/Library/Application Support/Avid/Audio/Plug-Ins (Unused)"

chmod a+w "/Library/Application Support/Avid/Audio/Plug-Ins"
chmod a+w "/Library/Application Support/Avid/Audio/Plug-Ins (Unused)"

mkdir /Users/Shared/Pro\ Tools
mkdir /Users/Shared/AvidVideoEngine

chown -R root:wheel /Users/Shared/*
chmod -R a+rw /Users/Shared/*

# Get rid of old workspace
rm -rf /Users/Shared/Pro\ Tools/Workspace.wksp

exit 0