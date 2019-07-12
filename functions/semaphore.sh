SEMAPHORE_NAME="migration.active"
SEMAPHORE_PATH="$(pwd)/$DATA_DIR/$SEMAPHORE_NAME"

function checkSemaphore() {
    if [ -f $SEMAPHORE_PATH ]; then
        return 1
    fi

    return 0
}

function createSemaphore() {
    touch $SEMAPHORE_PATH
}

function removeSemaphore () {
    if [ ! -f $SEMAPHORE_PATH ]; then
        return
    fi

    rm $SEMAPHORE_PATH
}

