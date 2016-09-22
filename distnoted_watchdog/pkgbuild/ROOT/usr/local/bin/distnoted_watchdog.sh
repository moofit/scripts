#!/bin/bash

PATH=/bin:/usr/bin
export PATH
logger "Checking distnoted"

# check for runaway distnoted, kill if necessary
ps -reo '%cpu,uid,pid,command' |
    awk -v UID=$UID '
    /distnoted agent$/ && $1 > 85.0 && $2 == UID {
        system("kill -9 " $3)
    }
    '
