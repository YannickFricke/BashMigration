DATA_DIR=".bm"
DATA_FILE="migrations.db"
DATA_PATH="$(pwd)/$DATA_DIR/$DATA_FILE"

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
    cat "$(pwd)/.bm/init.sql" | sqlite3 $DATA_PATH
}

function addMigration() {
    sqlite3 $DATA_PATH "INSERT INTO \"migrations\" (\"id\", \"name\") VALUES ('$3', '$4')"
}

function listMigrations() {
    sqlite3 $DATA_PATH "SELECT * FROM \"migrations\""
}

function hasMigration() {
    RESULT=`sqlite3 $DATA_PATH "SELECT COUNT(*) as count FROM migrations WHERE id = \"$1\""`

    if [ $RESULT -eq 1 ]; then
        return 1
    else
        return 0
    fi
}

function isMigrated() {
    RESULT=`sqlite3 $DATA_PATH "SELECT COUNT(*) as count FROM migrations WHERE id = \"$1\" and migrated = 1"`

    echo "Result migrated: $RESULT"

    if [ $RESULT -eq 1 ]; then
        echo "Has one result"
        return 1
    else
        return 0
    fi
}
