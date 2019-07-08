#!/usr/bin/env bash

source ./constants/index.sh
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
    migration_args=""

    if [ $# -eq 1 ]; then
        migration_args="all"
    else
        if [ $2 = "all" ]; then
            migration_args="all"
        else
            for item in "${@:2}"
            do
                if [ -z $migration_args ]; then
                    migration_args="$item"
                else
                    migration_args="$migration_args $item"
                fi
            done
        fi
    fi

    Migrate $migration_args
elif [ $1 = "unmigrate" ]; then
    unmigration_args=""

    if [ $# -eq 1 ]; then
        unmigration_args="all"
    else
        if [ $2 = "all" ]; then
            unmigration_args="all"
        else
            for item in "${@:2}"
            do
                if [ -z $migration_args ]; then
                    unmigration_args="$item"
                else
                    unmigration_args="$unmigration_args $item"
                fi
            done
        fi
    fi

    Unmigrate $unmigration_args
elif [ $1 = "version" ]; then
    ShowVersion
else
    echo "Unknown command: $1"
    showUsage $0
    exit 1
fi
