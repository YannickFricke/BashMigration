# Unmigrates to a specific revision
function Unmigrate() {
    echo "${GREEN}Starting unmigration!${RESET}"    

    checkSqlite

    if [ ! -d "$DATA_DIR" ]; then
        mkdir $DATA_DIR
    fi
    
    if [ ! -f "$DB_PATH" ]; then
        initSqlite
    fi

    if [ $1 = "all" ]; then
        echo "${BLUE}Unmigrating everything!${RESET}"
        unmigrateAll
        echo "${GREEN}Successfully unmigrated!${RESET}"
    else
        echo "${BLUE}Unmigrating only specific revisions:${RESET} ${@}"
        unmigrateSpecific ${@}
        echo "${GREEN}Successfully unmigrated!${RESET}"
    fi
}

function unmigrateAll() {
    for file in migrations/*.sh
    do
        unmigrateFile $file
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
    ID=`grep -oP '\K\d+' <<< $RESULT`

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

    if [ $is_migrated -eq 0 ]; then
        echo "${YELLOW}Migration ${WHITE}$file${YELLOW} is not migrated.${RESET}"
        return 0
    fi
    
    . $file
    migrateDown
    setMigrated $ID 0
    echo "${GREEN}Unmigrated file ${WHITE}$file${RESET}"
}

