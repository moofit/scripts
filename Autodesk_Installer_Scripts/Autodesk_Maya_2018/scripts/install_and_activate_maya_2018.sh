#!/bin/sh

# Installs and activates Autodesk Maya 2018 with a standalone license key

/tmp/Install\ Maya\ 2018.app/Contents/MacOS/setup --noui

/private/tmp/Install\ Maya\ 2018.app/Contents/Resources/adlmreg -i S 657J1 657J1 2018.0.0.F XXX-XXXXXXXX /Library/Application\ Support/Autodesk/Adlm/PIT/2018/MayaConfig.pit

mkdir /Library/Application\ Support/Autodesk/CLM/LGS/657J1_2018.0.0.F
touch /Library/Application\ Support/Autodesk/CLM/LGS/657J1_2018.0.0.F/LGS.data
chmod 777 /Library/Application\ Support/Autodesk/CLM/LGS/657J1_2018.0.0.F/LGS.data
echo "_STANDALONE" >> /Library/Application\ Support/Autodesk/CLM/LGS/657J1_2018.0.0.F/LGS.data
