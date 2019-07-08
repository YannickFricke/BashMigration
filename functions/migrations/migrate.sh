# Migrates all remaining revisions
function Migrate() {
    echo "Starting migration!"

    if [ $1 = "all" ]; then
        echo "Migrating everything!"
    else
        echo "Migrating only specific revisions"
    fi
    
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
        
        if [ ! -f "$DB_PATH" ]; then
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