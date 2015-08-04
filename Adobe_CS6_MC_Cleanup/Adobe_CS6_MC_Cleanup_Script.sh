#!/bin/sh

# Darren Wallace - Amsys
# Script using the "Chflags" command to hide a number of unwanted Adobe installed items.

echo "STARTING ADOBE CLEANUP"
# Starting at the "/Applications" folder

# Random top level Adobe folder
chflags hidden "/Applications/Adobe"

# The Adobe Acrobat Pro uninstaller
## For some reason this cannot be hidden and must be removed.
rm "/Applications/Adobe Acrobat X Pro/Acrobat X Uninstaller"

# Adobe After Effects CS6
chflags hidden "/Applications/Adobe After Effects CS6/aerender"
chflags hidden "/Applications/Adobe After Effects CS6/Legal"
chflags hidden "/Applications/Adobe After Effects CS6/Plug-ins"
chflags hidden "/Applications/Adobe After Effects CS6/Presets"
chflags hidden "/Applications/Adobe After Effects CS6/Scripts"
chflags hidden "/Applications/Adobe After Effects CS6/Uninstall Adobe After Effects CS6"

# Adobe Audition CS6
chflags hidden "/Applications/Adobe Audition CS6/Legal"
chflags hidden "/Applications/Adobe Audition CS6/Uninstall Adobe Audition CS6"

# Adobe Bridge CS6
chflags hidden "/Applications/Adobe Bridge CS6/Legal"
chflags hidden "/Applications/Adobe Bridge CS6/Plug-Ins"
chflags hidden "/Applications/Adobe Bridge CS6/Presets"
chflags hidden "/Applications/Adobe Bridge CS6/Required"

# Adobe Dreamweaver CS6
chflags hidden "/Applications/Adobe Dreamweaver CS6/Configuration"
chflags hidden "/Applications/Adobe Dreamweaver CS6/en_US"
chflags hidden "/Applications/Adobe Dreamweaver CS6/Installer"
chflags hidden "/Applications/Adobe Dreamweaver CS6/Legal"
chflags hidden "/Applications/Adobe Dreamweaver CS6/Sample_files"
chflags hidden "/Applications/Adobe Dreamweaver CS6/Uninstall Adobe Dreamweaver CS6"

# Adobe Encore CS6
chflags hidden "/Applications/Adobe Encore CS6/Legal"
chflags hidden "/Applications/Adobe Encore CS6/Uninstall Adobe Encore CS6"

# Adobe Extension Manager CS6
chflags hidden "/Applications/Adobe Extension Manager CS6/Legal"
chflags hidden "/Applications/Adobe Extension Manager CS6/Resources"

# Adobe Fireworks CS6
chflags hidden "/Applications/Adobe Fireworks CS6/bridgeDefaultLanguage"
chflags hidden "/Applications/Adobe Fireworks CS6/Configuration"
chflags hidden "/Applications/Adobe Fireworks CS6/Legal"
chflags hidden "/Applications/Adobe Fireworks CS6/Required"
chflags hidden "/Applications/Adobe Fireworks CS6/Uninstall Adobe Fireworks CS6"

# Adobe Flash Builder CS6
chflags hidden "/Applications/Adobe Flash Builder 4.6/Adobe Flash Builder 4.6 - Bitte lesen.pdf"
chflags hidden "/Applications/Adobe Flash Builder 4.6/Adobe Flash Builder 4.6 — Lisez-moi.pdf"
chflags hidden "/Applications/Adobe Flash Builder 4.6/Adobe Flash Builder 4.6 Read Me.pdf"
chflags hidden "/Applications/Adobe Flash Builder 4.6/Adobe Flash Builder 4.6 お読みください.pdf"
chflags hidden "/Applications/Adobe Flash Builder 4.6/Adobe Flash Builder 4.6 自述.pdf"
chflags hidden "/Applications/Adobe Flash Builder 4.6/assets"
chflags hidden "/Applications/Adobe Flash Builder 4.6/configuration"
chflags hidden "/Applications/Adobe Flash Builder 4.6/dropins"
chflags hidden "/Applications/Adobe Flash Builder 4.6/eclipse"
chflags hidden "/Applications/Adobe Flash Builder 4.6/Legal"
chflags hidden "/Applications/Adobe Flash Builder 4.6/p2"
chflags hidden "/Applications/Adobe Flash Builder 4.6/player"
chflags hidden "/Applications/Adobe Flash Builder 4.6/sdks"
chflags hidden "/Applications/Adobe Flash Builder 4.6/utilities"
chflags hidden "/Applications/Adobe Flash Builder 4.6/Важное о Adobe Flash Builder 4.6.pdf"
chflags hidden "/Applications/Adobe Flash Builder 4.6/Uninstall Adobe Flash Builder 4.6"

# Adobe Flash CS6
chflags hidden "/Applications/Adobe Flash CS6/AIR3.2"
chflags hidden "/Applications/Adobe Flash CS6/AIR3.4"
chflags hidden "/Applications/Adobe Flash CS6/Common"
chflags hidden "/Applications/Adobe Flash CS6/en_US"
chflags hidden "/Applications/Adobe Flash CS6/Legal"
chflags hidden "/Applications/Adobe Flash CS6/Players"
chflags hidden "/Applications/Adobe Flash CS6/XManConfig.xml"
chflags hidden "/Applications/Adobe Flash CS6/Uninstall Adobe Flash CS6"

# Adobe Illustrator CS6
chflags hidden "/Applications/Adobe Illustrator CS6/Configuration"
chflags hidden "/Applications/Adobe Illustrator CS6/Cool Extras.localized"
chflags hidden "/Applications/Adobe Illustrator CS6/Legal"
chflags hidden "/Applications/Adobe Illustrator CS6/Plug-ins.localized"
chflags hidden "/Applications/Adobe Illustrator CS6/Presets.localized"
chflags hidden "/Applications/Adobe Illustrator CS6/Read Me.localized"
chflags hidden "/Applications/Adobe Illustrator CS6/Scripting.localized"
chflags hidden "/Applications/Adobe Illustrator CS6/Uninstall Adobe Illustrator CS6"

# Adobe InDesign CS6
chflags hidden "/Applications/Adobe InDesign CS6/Configuration"
chflags hidden "/Applications/Adobe InDesign CS6/Documentation"
chflags hidden "/Applications/Adobe InDesign CS6/Fonts"
chflags hidden "/Applications/Adobe InDesign CS6/Legal"
chflags hidden "/Applications/Adobe InDesign CS6/Plug-Ins"
chflags hidden "/Applications/Adobe InDesign CS6/Presets"
chflags hidden "/Applications/Adobe InDesign CS6/Scripts"
chflags hidden "/Applications/Adobe InDesign CS6/Uninstall Adobe InDesign CS6"

# Adobe Media Encoder CS6
chflags hidden "/Applications/Adobe Media Encoder CS6/Configuration"

# Adobe Photoshop CS6
chflags hidden "/Applications/Adobe Photoshop CS6/Configuration"
chflags hidden "/Applications/Adobe Photoshop CS6/Legal"
chflags hidden "/Applications/Adobe Photoshop CS6/LegalNotices.pdf"
chflags hidden "/Applications/Adobe Photoshop CS6/Locales"
chflags hidden "/Applications/Adobe Photoshop CS6/Photoshop CS6 Read Me.pdf"
chflags hidden "/Applications/Adobe Photoshop CS6/Plug-ins"
chflags hidden "/Applications/Adobe Photoshop CS6/Presets"
chflags hidden "/Applications/Adobe Photoshop CS6/Uninstall Adobe Photoshop CS6"

# Adobe Prelude CS6 
chflags hidden "/Applications/Adobe Prelude CS6/Configuration"
chflags hidden "/Applications/Adobe Prelude CS6/Uninstall Adobe Prelude CS6"

# Adobe Premiere Pro CS6
chflags hidden "/Applications/Adobe Premiere Pro CS6/Configuration"
chflags hidden "/Applications/Adobe Premiere Pro CS6/Presets"
chflags hidden "/Applications/Adobe Premiere Pro CS6/Uninstall Adobe Premiere Pro CS6"

# Adobe SpeedGrade CS6
chflags hidden "/Applications/Adobe SpeedGrade CS6/Uninstall Adobe SpeedGrade CS6"

# Adobe Utilities folders
# Adobe Application Manager 
chflags hidden "/Applications/Utilities/Adobe Application Manager"

# Adobe Installers folder
chflags hidden "/Applications/Utilities/Adobe Installers"

# Adobe ExtendScript ToolKit
chflags hidden "/Applications/Utilities/Adobe Utilities-CS6.localized/ExtendScript Toolkit CS6/ExtendScript Toolkit ReadMe.pdf"
chflags hidden "/Applications/Utilities/Adobe Utilities-CS6.localized/ExtendScript Toolkit CS6/Legal"
chflags hidden "/Applications/Utilities/Adobe Utilities-CS6.localized/ExtendScript Toolkit CS6/SDK"

# Adobe Flash Player Install Manager
chflags hidden "/Applications/Utilities/Adobe Flash Player Install Manager.app"

echo "ADOBE CLEANUP COMPLETE"
exit 0

