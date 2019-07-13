# Unmigrates to a specific revision
function Unmigrate() {
    info "Starting unmigration!"

    # Check if the SQLite database exists
    checkSqlite

    # Check if the data directory exists
    if [ ! -d "$DATA_DIR" ]; then
        # Data directory does not exists
        # Creating it
        mkdir $DATA_DIR
    fi

    # Check if the database file exists
    if [ ! -f "$DB_PATH" ]; then
        # Initialize the database
        initSqlite
    fi

    if [ $1 = "all" ]; then
        info "Unmigrating all revisions!"
        unmigrateAll
        success $LEVEL_INFO "Successfully unmigrated all revisions!"
    else
        echo "Unmigrating only specific revisions: ${@}"
        unmigrateSpecific ${@}
        success $LEVEL_INFO "Successfully unmigrated the following revisions: ${@}"
    fi

    # Show a nice summary for the user
    showSummary "unmigrated" 0
}

# Unmigrates all revisions
function unmigrateAll() {
    for file in migrations/*.sh
    do
        debug "Unmigrating file: ${WHITE}$file"
        unmigrateFile $file
        debug "Unmigrated file ${WHITE}$file"
    done
}

# Unmigrates specific revisions
function unmigrateSpecific() {
    for revision in ${@}
    do
        for file in migrations/*.sh
        do
            if [[ $file != *"$revision"* ]]; then
                continue
            fi

            unmigrateFile $file
        done
    done
}

function unmigrateFile () {
    # Save the filename to a local variable
    local file=$1

    # Get the filename from the path
    local RESULT=`grep -oP 'migrations/\K\w+' <<< $file`

    # Extract the id of the migration
    local ID=`grep -oP '^\K\d+' <<< $RESULT`

    # Extract the name of the migration
    local NAME=`grep -oP '\d+_\K\w+' <<< $RESULT`

    # Check if we know about the revision
    hasMigration $ID

    # Assign the return value
    local has_migration=$?

    # When the return value equals to 0, we dont know about it
    if [ $has_migration -eq 0 ]; then
        info "Migration does not exists. Adding it."

        # Inserting the revision into the database
        insertMigration $ID $NAME
    fi

    # Check if the revision is already migrated
    isMigrated $ID

    # Assign the return value
    local is_migrated=$?

    # When the return value equals to 0, the revision is not migrated
    if [ $is_migrated -eq 0 ]; then
        info "${YELLOW}Migration ${WHITE}$file${YELLOW} is not migrated."
        return 0
    fi

    # Source the file
    . $file

    # Running the unmigration
    migrateDown

    # Assign the return value
    local MIGRATION_EXIT_STATUS=$?

    # Check if the return value is equals to 1
    # If yes, the unmigration was not successful and we rollback
    if [ $MIGRATION_EXIT_STATUS -eq 1 ]; then
        error "Unmigration of file ${WHITE}$file${RED} failed! Rolling back!${RESET}"

        warning "Rolling back all unmigrated revisions!${RESET}"

        rollback "unmigrate" "${ID}_${NAME}"

        showSummary "unmigrated" 1

        debug "Going to remove semaphore"
        removeSemaphore
        debug "Removed semaphore"
        exit 0
    fi

    # Set the new migration status for the revision
    setMigrated $ID 0

    # Add the revision to the processed migrations
    PROCESSED_MIGRATIONS+=("${ID}_${NAME}")
}
