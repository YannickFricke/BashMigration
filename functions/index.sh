# Load all logging functions
source "$INCLUDE_PATH/functions/logging.sh"

# Load all SQLite functions
source "$INCLUDE_PATH/functions/sqlite.sh"

# Load all custom filesystem functions
source "$INCLUDE_PATH/functions/filesystem.sh"

# Load all migration functions
source "$INCLUDE_PATH/functions/migrations.sh"

# Load the ShowVersion function
source "$INCLUDE_PATH/functions/version.sh"

# Load step functions
source "$INCLUDE_PATH/functions/steps.sh"

# Load package manager functions
source "$INCLUDE_PATH/functions/package_managers/index.sh"

# Load semaphore functions
source "$INCLUDE_PATH/functions/semaphore.sh"

# Load the summary function
source "$INCLUDE_PATH/functions/summary.sh"

# Load the rollback function
source "$INCLUDE_PATH/functions/rollback.sh"

# Load the requirement function
source "$INCLUDE_PATH/functions/requirements.sh"
