# Migrates all remaining revisions
function Migrate() {
    echo "${GREEN}Starting migration!${RESET}"

    checkSqlite

    if [ ! -d "$DATA_DIR" ]; then
        mkdir $DATA_DIR
    fi
    
    if [ ! -f "$DB_PATH" ]; then
        initSqlite
    fi

    if [ $1 = "all" ]; then
        echo "${BLUE}Migrating everything!${RESET}"
        migrateAll
        echo "${GREEN}Successfully migrated!${RESET}"
    else
        echo "${BLUE}Migrating only specific revisions:${RESET} ${@}"
        migrateSpecific ${@}
        echo "${GREEN}Successfully migrated!${RESET}"
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
    setMigrated $ID 1
    echo "${GREEN}Migrated file ${WHITE}$file${RESET}"
    PROCESSED_MIGRATIONS+=("${ID}_${NAME}")
}
