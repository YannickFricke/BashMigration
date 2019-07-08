# Load all SQLite functions
source "$INCLUDE_PATH/functions/sqlite.sh"

# Load all custom filesystem functions
source "$INCLUDE_PATH/functions/filesystem.sh"

# Load all migration functions
source "$INCLUDE_PATH/functions/migrations.sh"

# Load the ShowVersion function
source "$INCLUDE_PATH/functions/version.sh"
