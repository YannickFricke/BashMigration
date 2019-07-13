# Unmigrates to a specific revision
function Unmigrate() {
    info "Starting unmigration!"

    checkSqlite

    if [ ! -d "$DATA_DIR" ]; then
        mkdir $DATA_DIR
    fi
    
    if [ ! -f "$DB_PATH" ]; then
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

    showSummary "unmigrated" 0
}

function unmigrateAll() {
    for file in migrations/*.sh
    do
        debug "Unmigrating file: ${WHITE}$file"
        unmigrateFile $file
        debug "Unmigrated file ${WHITE}$file"
    done
}

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
    local file=$1

    # Get the filename from the path
    local RESULT=`grep -oP 'migrations/\K\w+' <<< $file`

    # Extract the id of the migration
    local ID=`grep -oP '^\K\d+' <<< $RESULT`

    # Extract the name of the migration
    local NAME=`grep -oP '\d+_\K\w+' <<< $RESULT`

    hasMigration $ID
    local has_migration=$?

    if [ $has_migration -eq 0 ]; then
        info "Migration does not exists. Adding it."
        insertMigration $ID $NAME
    fi
    
    isMigrated $ID
    local is_migrated=$?

    if [ $is_migrated -eq 0 ]; then
        info "${YELLOW}Migration ${WHITE}$file${YELLOW} is not migrated."
        return 0
    fi
    
    . $file
    migrateDown

    local MIGRATION_EXIT_STATUS=$?

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

    setMigrated $ID 0
    PROCESSED_MIGRATIONS+=("${ID}_${NAME}")
}
