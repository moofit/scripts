#!/bin/bash

echo | osascript <<EOF
tell application "Crashplan.app"
  quit
end tell
EOF

sleep 5

launchctl unload -wF /Library/LaunchDaemons/com.crashplan.engine.plist

chflags noschg

rm -R /Applications/CrashPlan.app
rm -R /Library/Logs/CrashPlan
rm -R /Users/$USER/Library/Logs/CrashPlan
rm -R /Library/Application\ Support/CrashPlan
rm -R /Library/Caches/CrashPlan
rm -R /Library/LaunchDaemons/com.crashplan.engine.plist

exit 0
