Mounts network drives on Mac OS X

There are two versions of this script:

shareConnect: This version is standalone and can be used natively in OS X
shareConnect_Casper: This version is intended to be used in Casper, using the standard script parameters. If its used as a login item it will take the standard logging in username variable $3.
shareConnect Usage

/path/to/shareConnect afp|smb|cifs serveraddress sharename groupName

E.g. shareConnect afp fileserver.company.internal myCompanyShare staff

If you are using share or group name with spaces, wrap the entry in quote marks, e.g. "my share".
