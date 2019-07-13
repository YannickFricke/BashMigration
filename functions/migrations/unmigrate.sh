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
        info "Migration does not exists. Adding it."
        insertMigration $ID $NAME
    fi
    
    isMigrated $ID
    is_migrated=$?

    if [ $is_migrated -eq 0 ]; then
        info "${YELLOW}Migration ${WHITE}$file${YELLOW} is not migrated."
        return 0
    fi
    
    . $file
    migrateDown
    setMigrated $ID 0
    PROCESSED_MIGRATIONS+=("${ID}_${NAME}")
}

