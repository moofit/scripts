#!/bin/bash

################################
#
# Script to reset home folder ownership
#
# Created by David Acland - Amsys
#
# Use at your own risk.  Amsys will accept
# no responsibility for loss or damage
# caused by this script.
#
################################
 
counter=`ls /Users | grep -v -E 'Shared|Guest|.localized|.DS_Store' | grep -c "[A-z 0-9]"`
     # Outputs the number of folders in the /Users directory, excluding the Shared & Guest directories
 
# Loop start
 
     while [ $counter -ne 0 ]
          do
               username=`ls /Users | grep -v -E 'Shared|Guest|.localized|.DS_Store' | grep "[A-z 0-9]" | head -$counter | tail -1`
                    # Gets the target folder name (there’s probably a better way to do this but it works!)
 
               chown -R $username /Users/$username
                    # Sets the folder owner
  
               counter=$(( $counter - 1 ))
                    # Reduces the counter by 1
     done
 
exit 0