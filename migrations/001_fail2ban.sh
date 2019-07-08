function migrateUp() {
    echo "Migrating up 001_test_migration"
    step "fail2ban"
    substep "Installing fail2ban"
    sudo $PKG_MANAGER install -y fail2ban
}

function migrateDown() {
    echo "Migrating down 001_test_migration"
    step "fail2ban"
    substep "Uninstalling fail2ban"
    sudo $PKG_MANAGER remove -y fail2ban
}
