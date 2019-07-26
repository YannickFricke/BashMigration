function checkRequirements() {
    local HAS_ERRORS=0

    # Check if SQLite command is available
    nohup sqlite3 2&>1
    local EXITCODE=$?
    rm 1

    if [[ $EXITCODE = 127 ]]; then
        # SQLite is not available
        error "SQLite is not available. Please install it before using BashMigration."
        HAS_ERRORS=1
    fi

    nohup grep 2&>1
    EXITCODE=$?
    rm 1

    if [[ $EXITCODE != 2 ]]; then
        # grep is not available
        error "grep is not available. Please install it before using BashMigration."
        HAS_ERRORS=1
    fi

    if [[ $HAS_ERRORS = 1 ]]; then
        exit 1
    fi
}
