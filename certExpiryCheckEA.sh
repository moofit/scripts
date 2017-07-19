#!/bin/bash

certName="<insert part or full cert name here"
certExpDate=$(/usr/bin/security find-certificate -a -c "${certName}" -p -Z "/Library/Keychains/System.keychain" | /usr/bin/openssl x509 -noout -enddate | cut -f2 -d=)
dateformat=$(/bin/date -j -f "%b %d %T %Y %Z" "${certExpDate}" "+%Y-%m-%d %H:%M:%S")
echo "<result>${dateformat}</result>"
