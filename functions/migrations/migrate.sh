# Migrates all remaining revisions
function Migrate() {
    echo "Migrating!"
    checkSqlite
    for f in migrations/*
    do
    echo "Processing migration: $f"

    # Get the filename from the path
    RESULT=`grep -oP 'migrations/\K\w+' <<< $f`

    # Extract the id of the migration
    ID=`grep -oP '\K\d+' <<< $RESULT`

    # Extract the name of the migration
    NAME=`grep -oP '\d+_\K\w+' <<< $RESULT`

    echo "ID: $ID"
    echo "Name: $NAME"
    echo "CWD: $(pwd)"

    DATA_DIR=".bm"
    DATA_FILE="migrations.db"

    if [ ! -d "$DATA_DIR" ]; then
        mkdir $DATA_DIR
    fi
    
    if [ ! -f "$DATA_DIR/$DATA_FILE" ]; then
        initSqlite
    fi
    
    echo ""
    echo "Migrations:"
    
    listMigrations

    hasMigration $ID
    HAS_MIGRATION=$?

    echo "has migration: $HAS_MIGRATION"
    
    isMigrated $ID
    IS_MIGRATED=$?

    echo "is migrated: $IS_MIGRATED"

    if [ $IS_MIGRATED -eq 1 ]; then
        continue
    fi

    echo "Migrating file: $f"

    . $f

    migrateUp

    done
}