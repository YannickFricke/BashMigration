function listMigrations() {
    for file in migrations/*.sh; do
        listMigrationStatus $file
    done
}

function listMigrationStatus() {
    file=$1
    RESULT=`grep -oP 'migrations/\K\w+' <<< $file`

    # Extract the id of the migration
    ID=`grep -oP '^\K\d+' <<< $RESULT`

    # Extract the name of the migration
    NAME=`grep -oP '\d+_\K\w+' <<< $RESULT`

    hasMigration $ID
    has_migration=$?

    if [ $has_migration -eq 0 ]; then
        echo "${RED}${ID}_${NAME}${RESET}"
        return 0
    fi
    
    isMigrated $ID
    is_migrated=$?

    if [ $is_migrated -eq 0 ]; then
        echo "${RED}${ID}_${NAME}${RESET}"
        return 0
    fi

    echo "${GREEN}${ID}_${NAME}${RESET}"
}