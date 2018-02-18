#!/bin/sh

# Author:   David Acland - Moof IT
# Name:     postinstall (Maya 2018)
# Full blog article relating to this script can be found here: https://www.moof-it.co.uk/blogs
#
# Purpose:  Maya 2018 Post-Install
# Installs and activates Autodesk Maya 2018 with a standalone license key
#
# Usage:    Postinstall script in PKG
# Replace XXX-XXXXXXXX with your license code on line 20
#
# Version 1.0.0, 2018-02-18
#   Initial Creation
#
# Use at your own risk.  Amsys will accept no responsibility for loss or damage
# caused by this script.

/tmp/Install\ Maya\ 2018.app/Contents/MacOS/setup --noui

/private/tmp/Install\ Maya\ 2018.app/Contents/Resources/adlmreg -i S 657J1 657J1 2018.0.0.F XXX-XXXXXXXX /Library/Application\ Support/Autodesk/Adlm/PIT/2018/MayaConfig.pit

mkdir /Library/Application\ Support/Autodesk/CLM/LGS/657J1_2018.0.0.F
touch /Library/Application\ Support/Autodesk/CLM/LGS/657J1_2018.0.0.F/LGS.data
chmod 777 /Library/Application\ Support/Autodesk/CLM/LGS/657J1_2018.0.0.F/LGS.data
echo "_STANDALONE" >> /Library/Application\ Support/Autodesk/CLM/LGS/657J1_2018.0.0.F/LGS.data
