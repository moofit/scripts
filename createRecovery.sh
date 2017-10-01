
#!/bin/sh

######################################
#
# Create Recovery script					  
#
# Usage: ./createRecovery.sh
#
# Created by Amsys
#
# Use at your own risk.  Amsys will accept
# no responsibility for loss or damage
# caused by this script.
#
# The script will perform the following tasks:
#
# 1. Set the macOS installer path as a variable
# 2. Set the target disk as a variable
# 3. Download the RecoveryHDUpdate.dmg into /private/tmp
# 4. Open the disk image
# 5. Expand the enclosed "RecoveryHDUpdate.pkg" package
# 6. Eject the disk image
# 7. Create or modify the Recovery partition
#
######################################

# Set the macOS installer path as a variable
MACOS_INSTALLER="/Applications/$(ls /Applications | grep "Install macOS")"      # Path to your macOS installer
echo "macOS installer is $MACOS_INSTALLER"

# Set the target disk as a variable
TARGET=$(diskutil info "$(bless --info --getBoot)" | awk -F':' '/Volume Name/ { print $2 }' | sed -e 's/^[[:space:]]*//')
echo "Target disk is $TARGET"

# Download the RecoveryHDUpdate.dmg into /private/tmp
curl http://support.apple.com/downloads/DL1464/en_US/RecoveryHDUpdate.dmg -L -o /private/tmp/RecoveryHDUpdate.dmg
echo "Downloaded RecoveryHDUpdate.dmg into /private/tmp"

# Open the disk image
hdiutil attach /private/tmp/RecoveryHDUpdate.dmg

# Expand the enclosed "RecoveryHDUpdate.pkg" package
pkgutil --expand /Volumes/Mac\ OS\ X\ Lion\ Recovery\ HD\ Update/RecoveryHDUpdate.pkg /private/tmp/recoveryupdate
echo "RecoveryHDUpdate.pkg expanded into /private/tmp/recoveryupdate"

# Eject the disk image
hdiutil eject "/Volumes/Mac OS X Lion Recovery HD Update"

if [ "$MACOS_INSTALLER" = "/Applications/Install macOS High Sierra.app" ]; then
	# Create or modify the Recovery partition (10.13)
	echo "Installer is macOS High Sierra"
	/private/tmp/recoveryupdate/RecoveryHDUpdate.pkg/Scripts/Tools/dmtest ensureRecoveryPartition "$TARGET" "$MACOS_INSTALLER/Contents/SharedSupport/BaseSystem.dmg" 0 0 "$MACOS_INSTALLER/Contents/SharedSupport/BaseSystem.chunklist"
	echo "Finished creating High Sierra Recovery HD"
else
	if [ "$MACOS_INSTALLER" = "/Applications/Install macOS Sierra.app" ]; then
	# Create or modify the Recovery partition (10.12)
	echo "Installer is macOS Sierra"
	hdiutil mount "$MACOS_INSTALLER/Contents/SharedSupport/InstallESD.dmg"
	/private/tmp/recoveryupdate/RecoveryHDUpdate.pkg/Scripts/Tools/dmtest ensureRecoveryPartition "$TARGET" "/Volumes/OS X Install ESD/BaseSystem.dmg" 0 0 "/Volumes/OS X Install ESD/BaseSystem.chunklist"
	hdiutil eject "/Volumes/OS X Install ESD"
	echo "Finished creating Sierra Recovery HD"
	fi
fi
