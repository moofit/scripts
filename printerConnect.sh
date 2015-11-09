#!/bin/bash

######################################
#
# Printer mapping script					  
#
# Usage: printerConnect name url ppd
#
# Created by Amsys
#
# Use at your own risk.  Amsys will accept
# no responsibility for loss or damage
# caused by this script.
#
######################################

name="$4"		# This is the name of the printer, e.g. MyGreatPrinter
url="$5"		# This is the URL of the printer, e.g. ipp://fp01.ac.uk/printers/printer1
ppd="$6"		# This is the path to the ppd file, e.g. /Library/Printers/PPDs/Contents/Resources/HP LaserJet 4000 Series.gz

# Map the printer
lpadmin -E -p "${name}" -v "${url}" -P "${ppd}" -o printer-is-shared=false -o PageSize=A4 -o auth-info-required=negotiate

exit 0
