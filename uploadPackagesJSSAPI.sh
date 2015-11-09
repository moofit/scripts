#!/bin/bash
#
################################################
#
# Upload packages to Casper
#
# 2015 - Amsys - DA
#
################################################

# Variables

apiURL="https://casperurl.com:8443"
apiUser="username"
apiPass="password"
pathToPackages="/Volumes/Data/CasperDP/Packages"

# Advanced modification below this line

if [ ! -d /private/tmp/Packages ]; then
	mkdir /private/tmp/Packages
fi	

for PACKAGE in $(ls $pathToPackages)
     do
		echo "<package>" > /private/tmp/Packages/$PACKAGE.xml
  		echo " <name>$PACKAGE</name>" >> /private/tmp/Packages/$PACKAGE.xml
 		echo " <filename>$PACKAGE</filename>" >> /private/tmp/Packages/$PACKAGE.xml
		echo " <priority>10</priority>" >> /private/tmp/Packages/$PACKAGE.xml
		echo " <reboot_required>false</reboot_required>" >> /private/tmp/Packages/$PACKAGE.xml
		echo " <boot_volume_required>true</boot_volume_required>" >> /private/tmp/Packages/$PACKAGE.xml
		echo "</package>" >> /private/tmp/Packages/$PACKAGE.xml

curl -sfku $apiUser:$apiPass $apiURL/JSSResource/packages -T /private/tmp/Packages/$PACKAGE.xml -X POST

done

exit 0