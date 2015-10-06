#!/bin/bash

# Disable Adobe Flash auto updates with sed

sed -i '' -e 's/SilentAutoUpdateEnable=1/SilentAutoUpdateEnable=0/' /Library/Application\ Support/Macromedia/mms.cfg
sed -i '' -e 's/AutoUpdateDisable=0/AutoUpdateDisable=1/' /Library/Application\ Support/Macromedia/mms.cfg

exit 0
