function Migrate() {
    info "Starting migration!"

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

    # Check the migration arguments
    if [ $1 = "all" ]; then
        # We received the argument "all"
        # So we migrate all revisions
        info "Migrating all revisions!"

        # Migrating all revisions
        migrateAll

        # Successfully migrated all revisions
        success "INFORMATIONAL" "Successfully migrated!"
    else
        # We got specific revisions to migrate
        info "Migrating only specific revisions: ${@}"

        # Migrate only these specific revisions
        migrateSpecific ${@}

        # Successfully migrated the specified revisions
        success "INFORMATIONAL" "Successfully migrated!"
    fi

    # Show the summary
    showSummary "migrated" 0
}

# Migrates all revisions
function migrateAll() {
    for file in migrations/*.sh
    do
        migrateFile $file
    done
}

# Migrates only specific revisions
function migrateSpecific() {
    for revision in ${@}
    do
        for file in migrations/*.sh
        do
            if [[ $file != *"$revision"* ]]; then
                continue
            fi

            migrateFile $file
        done
    done
}

function migrateFile() {
    # Get the filename which should be migrated
    file=$1

    # Get the filename from the path
    local RESULT=`grep -oP 'migrations/\K\w+' <<< $file`

    # Extract the id of the migration
    local ID=`grep -oP '^\K\d+' <<< $RESULT`

    # Extract the name of the migration
    local NAME=`grep -oP '\d+_\K\w+' <<< $RESULT`

    # Check if we know about the migration
    hasMigration $ID

    # Assign the return value
    local has_migration=$?

    # We don't know about the migration
    if [ $has_migration -eq 0 ]; then
        echo "${CYAN}Migration does not exists. Adding it.${RESET}"

        # Insert the migration
        insertMigration $ID $NAME
    fi

    # Check if the revision is migrated
    isMigrated $ID

    # Assign the return value
    local is_migrated=$?

    # Check if the revision is migrated
    if [ $is_migrated -eq 1 ]; then
        echo "${YELLOW}Migration ${WHITE}$file${YELLOW} is already migrated.${RESET}"
        return 0
    fi

    # The revision is not migrated
    # So we do it now

    # Source the file
    . $file

    # Migrate the revision
    migrateUp

    # Assign the return value
    local MIGRATION_EXIT_STATUS=$?

    # Check if the return value is equals to 1
    # If yes, the migration was not successful and we rollback
    if [ $MIGRATION_EXIT_STATUS -eq 1 ]; then
        error "Migration of file ${WHITE}$file${RED} failed! Rolling back!${RESET}"

        warning "Rolling back all migrated revisions!${RESET}"

        # Rolling back all changes
        rollback "migrate" "${ID}_${NAME}"

        # Show the summary
        showSummary "migrated" 1

        debug "Going to remove semaphore"
        removeSemaphore
        debug "Removed semaphore"
        exit 0
    fi

    # Migration was successfull

    # Set the migration status
    setMigrated $ID 1
    echo "${GREEN}Migrated file ${WHITE}$file${RESET}"

    # Add the revision to the processed migrations
    PROCESSED_MIGRATIONS+=("${ID}_${NAME}")
}
