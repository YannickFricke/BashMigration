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

function addMigration() {
    sqlite3 $DB_PATH "INSERT INTO migrations (id, name) VALUES ('$3', '$4')"
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
