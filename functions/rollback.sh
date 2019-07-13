function rollback() {
    local COMMAND=$1
    local CURRENTY_ENTRY=$2

    if [ ${#PROCESSED_MIGRATIONS} -eq 0 ]; then
        warning "${MAGENTA}[ROLLBACK] Nothing to undo!"

        return 0
    fi

    if [ $COMMAND = "migrate" ]; then
        for entry in "${PROCESSED_MIGRATIONS[*]}"; do
            # Extract the id of the migration
            local ID=`grep -oP '^\K\d+' <<< $entry`

            . ./migrations/$entry.sh
            migrateDown
            setMigrated $ID 0

            success $LEVEL_INFO "${MAGENTA}[ROLLBACK] Remigrated $entry"
        done

        local ID=`grep -oP '^\K\d+' <<< $CURRENTY_ENTRY`
        . ./migrations/$CURRENTY_ENTRY.sh
        migrateDown
        setMigrated $ID 0

    elif [ $COMMAND = "unmigrate" ]; then
        for entry in "${PROCESSED_MIGRATIONS[*]}"; do
            # Extract the id of the migration
            ID=`grep -oP '^\K\d+' <<< $entry`

            . ./migrations/$entry.sh
            migrateUp
            setMigrated $ID 1

            info "${MAGENTA}[ROLLBACK] Remigrated $entry"
        done

        local ID=`grep -oP '^\K\d+' <<< $CURRENTY_ENTRY`
        . ./migrations/$CURRENTY_ENTRY.sh
        migrateUp
        setMigrated $ID 1
    fi

}