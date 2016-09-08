#!/bin/sh
#
# check for runaway distnoted, kill if necessary
#
PATH=/bin:/usr/bin
export PATH
logger "Checking distnoted"
ps -reo '%cpu,uid,pid,command' |
   awk -v UID=$UID '
   /distnoted agent$/ && $1 > 100.0 && $2 == UID {
       system("kill -9 " $3)
   }
   '