function checkSqlite() {
    sqlite3 -version 2&>1 > /dev/null
    local EXITCODE=$?
    rm 1

    if [ $EXITCODE -eq 127 ]; then
        echo "Could not find sqlite3"
        exit 1
    fi
}

function initSqlite() {
    echo $INIT_SQL | sqlite3 $DB_PATH
}

function listNotMigratedMigrations() {
    sqlite3 $DB_PATH "SELECT id, name FROM migrations where migrated = 0"
}

function listMigratedMigrations() {
    sqlite3 $DB_PATH "SELECT id, name FROM migrations where migrated = 1"
}

function listMigrations() {
    sqlite3 $DB_PATH "SELECT * FROM migrations"
}

function hasMigration() {
    RESULT=`sqlite3 $DB_PATH "SELECT COUNT(*) as count FROM migrations WHERE id = \"$1\""`

    if [ $RESULT -eq 1 ]; then
        return 1
    else
        return 0
    fi
}

function isMigrated() {
    RESULT=`sqlite3 $DB_PATH "SELECT COUNT(*) as count FROM migrations WHERE id = \"$1\" and migrated = 1"`

    if [ $RESULT -eq 1 ]; then
        return 1
    else
        return 0
    fi
}

function setMigrated() {
    ID=$1
    MIGRATION_STATUS=$2

    RESULT=`sqlite3 $DB_PATH "UPDATE migrations SET migrated = $MIGRATION_STATUS WHERE id = \"$ID\""`
}

function insertMigration() {
    ID=$1
    NAME=$2

    hasMigration $ID
    has_migration=$?

    # Check if the migration already exists
    if [ $has_migration -eq 1 ]; then
        return 0
    fi

    RESULT=`sqlite3 $DB_PATH "INSERT INTO migrations (id, name) VALUES ('$ID', '$NAME')"`
}
