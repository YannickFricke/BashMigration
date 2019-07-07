#!/usr/bin/env bash

source ./Version.sh
source ./functions/index.sh

function showUsage () {
    echo "$1"
    echo "-----------------------------------"
    echo "Commands"
    echo "- migrate"
    echo "- unmigrate"
    echo "- version"
    echo "-----------------------------------"
    echo "Version: $BM_VERSION"
}

if [ $# -lt 1 ]; then
    showUsage $0
    exit 0
fi

if [ $1 = "migrate" ]; then
    Migrate
elif [ $1 = "unmigrate" ]; then
    Unmigrate
elif [ $1 = "version" ]; then
    ShowVersion
else
    echo "Unknown command: $1"
    showUsage $0
    exit 1
fi
