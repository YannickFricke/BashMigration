SUMMARY_FILES=$()

function showSummary() {
    local SUMMARY_TYPE=$1
    local HAS_ERROR=$2
    local FILES="${PROCESSED_MIGRATIONS[*]}"

    if [ ${#PROCESSED_MIGRATIONS[*]} -eq 0 ]; then
        FILES="NONE"
    fi

    info "================== Summary =================="

    if [ $SUMMARY_TYPE = "migrated" ]; then
        if [ $HAS_ERROR -eq 1 ]; then
            info "Migrated files: ${RED}NONE"
        else
            info "Migrated files: ${GREEN}$FILES"
        fi
    elif [ $SUMMARY_TYPE = "unmigrated" ]; then
        if [ $HAS_ERROR -eq 1 ]; then
            info "Migrated files: ${RED}NONE"
        else
            info "Unmigrated files: ${RED}$FILES"
        fi
    else
        error "Unknown summary type: $SUMMARY_TYPE"
        return 0
    fi

    showNotChangedFiles $SUMMARY_TYPE

    info "============================================="
}

function showNotChangedFiles() {
    local VALUE=""

    for entry in ${SUMMARY_FILES[*]}; do
        # Extract the id of the migration
        local ID=`grep -oP '^\K\d+' <<< $entry`

        # Extract the name of the migration
        local NAME=`grep -oP '\d+_\K\w+' <<< $entry`

        if [ -z $VALUE ]; then
            VALUE="$entry"
        else
            VALUE="$VALUE $entry"
        fi
    done

    if [[ $VALUE = "" ]]; then
        VALUE="NONE"
    fi

    if [ $SUMMARY_TYPE = "migrated" ]; then
        info "Already migrated files: ${YELLOW}$VALUE"
    elif [ $SUMMARY_TYPE = "unmigrated" ]; then
        info "Already unmigrated files: ${YELLOW}$VALUE"
    fi
}

function setSummaryStatus() {
    if [ ! -d "$(pwd)/$DATA_DIR" ]; then
        debug "Creating data directory"
        mkdir "$(pwd)/$DATA_DIR"
    fi

    local COMMAND=$1

    if [ $COMMAND = "migrate" ]; then
        FUNCTION_NAME="listMigratedMigrations"
    elif [ $COMMAND = "unmigrate" ]; then
        FUNCTION_NAME="listNotMigratedMigrations"
    else
        return 0
    fi

    debug "Determined summary status command: $COMMAND = $FUNCTION_NAME"

    local RESULT=`$FUNCTION_NAME`

    for entry in $RESULT; do
        # Extract the id of the migration
        local ID=`grep -oP '^\K\d+' <<< $entry`

        # Extract the name of the migration
        local NAME=`grep -oP '\d+\|\K\w+' <<< $entry`

        SUMMARY_FILES+=("${ID}_${NAME}")
    done

    debug "Found the following summary files:${SUMMARY_FILES[*]}"
}
