#!/usr/bin/env bash

# Set the global INCLUDE_PATH variable
INCLUDE_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )

# Include all constants
source "$INCLUDE_PATH/constants/index.sh"

# Include all functions
source "$INCLUDE_PATH/functions/index.sh"

# Check if all requirements are available
checkRequirements

# Shows the usage of the tool
function showUsage () {
    echo "$1"
    echo "-----------------------------------"
    echo "Commands"
    echo "- migrate"
    echo "- unmigrate"
    echo "- list"
    echo "- version"
    echo "-----------------------------------"
    echo "Version: $BM_VERSION"
}

# Check if we have more than one argument
if [ $# -lt 1 ]; then
    # We have only one argument
    # Print usage and exit
    showUsage $0
    exit 0
fi

# Extract the command from the arguments
COMMAND=$1

# Set the summary status
# Needed to be set here before any command ran
setSummaryStatus $COMMAND

if [ $COMMAND = "migrate" ]; then
    # Check if the semaphore exists
    checkSemaphore

    # Save the return value of the executed function
    SEMAPHORE_EXISTS=$?

    # Check if the semaphore exists
    if [ $SEMAPHORE_EXISTS = "1" ]; then
        echo "Semaphore exists. Do not going to migrate."
        exit 1
    fi

    # Create the semaphore so no other migration can run
    createSemaphore

    # Read the migration arguments
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

    # Start the migration
    Migrate $migration_args

    # We finished the migration successfully
    # Remove the semaphore
    removeSemaphore
elif [ $COMMAND = "unmigrate" ]; then
    # Check if the semaphore exists
    checkSemaphore

    # Save the return value of the executed function
    SEMAPHORE_EXISTS=$?

    # Check if the semaphore exists
    if [ $SEMAPHORE_EXISTS = "1" ]; then
        echo "Semaphore exists. Do not going to unmigrate."
        exit 1
    fi

    # Create the semaphore so no other migration can run
    createSemaphore

    # Read the unmigration arguments
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

    # Start the unmigration
    Unmigrate $unmigration_args

    # Unmigration was successfull
    # Remove the semaphore
    removeSemaphore
elif [ $COMMAND = "list" ]; then
    echo "A green line means that the migration is applied"
    echo "A red line means that the migration is not applied"

    listMigrations
elif [ $COMMAND = "version" ]; then
    # Print the current version
    ShowVersion
else
    # We don't know about the command
    echo "Unknown command: $COMMAND"

    # Print the usage
    showUsage $0

    # And exit with the status code 1 to indicate an unsuccessful run
    exit 1
fi
