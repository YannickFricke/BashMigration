# Migrates all remaining revisions
function Migrate() {
    info "Starting migration!"

    checkSqlite

    if [ ! -d "$DATA_DIR" ]; then
        mkdir $DATA_DIR
    fi
    
    if [ ! -f "$DB_PATH" ]; then
        initSqlite
    fi

    if [ $1 = "all" ]; then
        info "Migrating all revisions!"
        migrateAll
        success "INFORMATIONAL" "Successfully migrated!"
    else
        info "Migrating only specific revisions: ${@}"
        migrateSpecific ${@}
        success "INFORMATIONAL" "Successfully migrated!"
    fi
}

function migrateAll() {
    for file in migrations/*.sh
    do
        migrateFile $file
    done
}

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
    file=$1

    # Get the filename from the path
    RESULT=`grep -oP 'migrations/\K\w+' <<< $file`

    # Extract the id of the migration
    ID=`grep -oP '^\K\d+' <<< $RESULT`

    # Extract the name of the migration
    NAME=`grep -oP '\d+_\K\w+' <<< $RESULT`

    hasMigration $ID
    has_migration=$?

    if [ $has_migration -eq 0 ]; then
        echo "${CYAN}Migration does not exists. Adding it.${RESET}"
        insertMigration $ID $NAME
    fi
    
    isMigrated $ID
    is_migrated=$?

    if [ $is_migrated -eq 1 ]; then
        echo "${YELLOW}Migration ${WHITE}$file${YELLOW} is already migrated.${RESET}"
        return 0
    fi
    
    . $file
    migrateUp

    local MIGRATION_EXIT_STATUS=$?

    if [ $MIGRATION_EXIT_STATUS -eq 1 ]; then
        error "Migration of file ${WHITE}$file${RED} failed! Rolling back!${RESET}"

        warning "Rolling back all applied migrations!${RESET}"

        debug "Going to remove semaphore"
        removeSemaphore
        debug "Removed semaphore"
        exit 0
    fi
    

    setMigrated $ID 1
    echo "${GREEN}Migrated file ${WHITE}$file${RESET}"
    PROCESSED_MIGRATIONS+=("${ID}_${NAME}")
}
