#!/bin/bash

# Created by Darren Wallace - Amsys
#

username="$3"
    if [ -z "$username" ]; then		# Checks if the variable is empty (user running script from Self Service)
        username="$USER"
    fi
    echo "User: $username"
Group1="$4"	# This is the first group to launch the first app for (staff)
    echo "AD User Group 1: $4"
Group2="$5"	# This is the second group to launch the second app for (student)
    echo "AD User Group 2: $5"
Group1AppLocation="$6"	# This is the full path to the first app (staff)
    echo "First App Location: $6"
Group2AppLocation="$7"		# This is the full path to the second app (student)
    echo "Second App Location: $7"

# Check that the user is in group 1 (Staff)
groupCheck=`dseditgroup -o checkmember -m $username "$Group1" | grep -c "yes"`
		if [ "${groupCheck}" -ne 0 ]; then
		    su "$username" -c "$(open -F $Group1AppLocation)"
		    exit 0
		fi
		
# Check that the user is in group 2 (Student)
groupCheck=`dseditgroup -o checkmember -m $username "$Group2" | grep -c "yes"`
		if [ "${groupCheck}" -ne 0 ]; then
		    su "$username" -c "$(open -F $Group2AppLocation)"
		fi

exit 0