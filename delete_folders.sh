#!/bin/sh

# WARNING - This script deletes folders (intentionally)
# Use at your own risk
# Intended for use on shared computers in AD environments where old home folders build up over time
# In this example we are targetting the contents of the /Users directory
# Replace "ABC123" with the string you want to search for
# The script will delete all items it finds that start with the specified string

ls /Users | grep '^ABC123' | while read folder ; do echo "Deleting /Users/$folder" && rm -R "/Users/$folder" ; done

exit 0
