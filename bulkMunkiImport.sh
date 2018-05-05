#!/bin/bash

# Author:   Stephen Bygrave - Moof IT
# Name:     bulkMunkiImport.sh
#
# Purpose:  Runs over a folder of packages, importing them in bulk into a Munki
#           repository
# Usage:    Script from Terminal
#
# Version 1.0.0, 2017-08-16
#   Initial Creation

# Use at your own risk.  Amsys will accept no responsibility for loss or damage
# caused by this script.

##### Define Flags and Help function

help ()
{
    echo "
    Usage: /path/to/bulkMunkiImport.sh [-h] [-v] -p /path/to/importFolder -c category -d developer [-r requires]
    Mandatory options are without square brackets; these must be defined at run time else the script will fail.

        -h              This help message
        -v              Verbose mode. Output all the things
        -p Folder       Supply path to the folder for the script to run on.
        -c Category     Supply the category to be used during Munki Import
        -d Developer    Supply the developer to be used during Munki Import
        -r Requires     Supply any packages that the imported packages will require

    Examples:

        /path/to/bulkMunkiImport.sh -v -p /path/to/importFolder -c Applications -d Apple
        /path/to/bulkMunkiImport.sh -p /path/to/importFolder -c Loops -d Apple -r LogicProX
    "
    exit 1
}

while getopts 'hvp:c:d:r:' flag;
do
    case "${flag}" in
        h )
            help
            ;;
        v )
            debug="1"
            ;;
        p )
            pathToImport="${OPTARG}"
            ;;
        c )
            pkgCategory="${OPTARG}"
            ;;
        d )
            pkgDeveloper="${OPTARG}"
            ;;
        r )
            requires="${OPTARG}"
            ;;
        * ) echo "Unexpected option ${flag}"
            help
            ;;
    esac
done

##### Set variables

logProcess="Bulk_Munki_Import"

##### Declare functions

writelog ()
{
    /usr/bin/logger -is -t "${logProcess}" "${1}"
}

echoVariables ()
{
    echo "Log process is ${logProcess}"
    echo "Path to import is ${pathToImport}"
    echo "Package Category is ${pkgCategory}"
    echo "Package Developer is ${pkgDeveloper}"
    echo "Requires is set to ${requires}"
}

checkFolder ()
{
    if [[ "${pathToImport}" == "" ]];
    then
        writelog "No path to pkg folder defined. Please enter path to import during runtime. Exiting..."
    fi
}

importToMunki ()
{
    if [[ -f "/usr/local/munki/munkiimport" && -f "/usr/local/munki/makecatalogs" ]];
    then
        find "${pathToImport}" -type f -name ".pkg" | while read pkg;
        do
            writelog "Importing ${pkg}..."
            if [[ "${requires}" != "" ]];
            then
                /usr/local/munki/munkiimport "${pkg}" --nointeractive --unattended_install --category="${pkgCategory}" --developer="${pkgDeveloper}" --requires="${requires}"
            else
                /usr/local/munki/munkiimport "${pkg}" --nointeractive --unattended_install --category="${pkgCategory}" --developer="${pkgDeveloper}"
            fi
            if [[ "${?}" -eq 0 ]];
            then
                writelog "${pkg} imported successfully."
            else
                writelog "ERROR: Could not import ${pkg}. Skipping..."
            fi
        done
        /usr/local/munki/makecatalogs
    else
        writelog "The munkiimport or makecatalogs binaries cannot be found. Unable to import. Bailing..."
        exit 0
    fi
}

##### Run script

if [[ "${pathToImport}" == "" || "${pkgCategory}" == "" || "${pkgDeveloper}" == "" ]];
then
    writelog "Mandatory options not defined. Please specify at runtime"
    help
fi

if [[ ${debug} -eq 1 ]];
then
    writelog " "
    writelog "##### Debug Mode"
    writelog " "
    echoVariables
fi

checkFolder
importToMunki

writelog "Script completed."
