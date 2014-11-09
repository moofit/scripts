#!/bin/sh

#!/bin/sh

################################
#
# appQuit script
# 
# Gracefully quits apps passed to it.
#
# Usage: appQuit.sh nameof app
# E.g: appQuit.sh Calculator.app
#
# Created by David Acland - Amsys
#
# Use at your own risk.  Amsys will accept
# no responsibility for loss or damage
# caused by this script.
#
################################

echo | osascript <<EOF
tell application "$*"
  quit
end tell
EOF