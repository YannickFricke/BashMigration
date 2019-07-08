function aptitudeUpdate() {
    sudo aptitude update
}

function aptitudeUgrade() {
    sudo aptitude upgrade -y
}

function aptitudeInstall() {
    sudo aptitude install -y ${@}
}

function aptitudeRemove() {
    sudo aptitude remove -y ${@}
}

function aptitudePurge() {
    sudo aptitude purge -y ${@}
}

function aptitudeClean() {
    sudo aptitude clean
}

function aptitudeReinstall() {
    sudo aptitude reinstall -y ${@}
}

function aptitudeFixBroken() {
    sudo aptitude install -f -y
}
