#!/bin/bash

# Variables

apiURL="https://casper2.amsys.co.uk/template"
apiUser="EA_API_USER"
apiPass="EA_API_PASSWORD"

###### Do not edit below this line

dscacheutil -flushcache

sleep 5

# Check if the computer is on the network by reading its own computer object from AD

	# Get Domain from full structure, cut the name and remove space.
	ShortDomainName=`dscl /Active\ Directory/ -read . | grep SubNodes | sed 's|SubNodes: ||g'`

	computer=$(dsconfigad -show | grep "Computer Account" | awk '{ print $4 }')
	dscl /Active\ Directory/$ShortDomainName/All\ Domains -read /Computers/$computer RecordName &>/dev/null
	
	if [ ! $? == 0 ] ; then 
		result="No connection to the domain"
		exit 1
	else
		result="Connected to $ShortDomainName"
	fi

# Upload result of AD connection test

echo "<computer>" > /private/tmp/EA.xml
echo " <extension_attributes>" >> /private/tmp/EA.xml
echo "  <extension_attribute>" >> /private/tmp/EA.xml
echo "   <name>AD Connection Status</name>" >> /private/tmp/EA.xml
echo "   <value>$result</value>" >> /private/tmp/EA.xml
echo " 	</extension_attribute>" >> /private/tmp/EA.xml
echo " </extension_attributes>" >> /private/tmp/EA.xml
echo "</computer>" >> /private/tmp/EA.xml

serial=$(system_profiler SPHardwareDataType | grep 'Serial Number (system)' | awk '{print $NF}')
echo $serial
curl -sfku $apiUser:$apiPass $apiURL/JSSResource/computers/serialnumber/$serial/subset/extensionattributes -T /private/tmp/EA.xml -X PUT

sleep 5

#rm /private/tmp/EA.xml
	
exit 0
