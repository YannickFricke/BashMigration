# Migrates all remaining revisions
function Migrate() {
    echo "Migrating!"
    checkSqlite
    for f in migrations/*.sh
    do
        echo "Processing migration: $f"

        # Get the filename from the path
        RESULT=`grep -oP 'migrations/\K\w+' <<< $f`

        # Extract the id of the migration
        ID=`grep -oP '\K\d+' <<< $RESULT`

        # Extract the name of the migration
        NAME=`grep -oP '\d+_\K\w+' <<< $RESULT`

        if [ ! -d "$DATA_DIR" ]; then
            mkdir $DATA_DIR
        fi
        
        if [ ! -f "$DATA_DIR/$DATA_FILE" ]; then
            initSqlite
        fi
        
        hasMigration $ID
        HAS_MIGRATION=$?

        isMigrated $ID
        IS_MIGRATED=$?

        if [ $IS_MIGRATED -eq 1 ]; then
            continue
        fi

        echo "Migrating file: $f"

        . $f
        migrateUp

        echo "Migrated file: $f"
    done
}