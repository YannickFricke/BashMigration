function aptUpdate() {
    sudo apt-get update
}

function aptUgrade() {
    sudo apt-get upgrade -y
}

function aptInstall() {
    sudo apt-get install -y ${@}
}

function aptRemove() {
    sudo apt-get remove -y ${@}
}

function aptPurge() {
    sudo apt-get purge -y ${@}
}

function aptClean() {
    sudo apt-get clean
}

function aptReinstall() {
    sudo apt-get reinstall -y ${@}
}

function aptFixBroken() {
    sudo apt-get install -f
}
