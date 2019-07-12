# Bash-Migration

## About the project

Bash-Migration is a tool for applying migrations to a server.

You can specify single actions in one file.

Then we track the revisions and apply
them when they are not migrated yet.

We also support the unmigration for reversing
applied revisions.

## Requirements

- bash (tested with version 5.0.3)
- grep (with Perl style regex support) (tested with version 3.3)
- SQLite (the `sqlite3` command must be available for the command line) (tested with version 3.28.0)

## Commands

|   Name    | Description                                                            |
| :-------: | :--------------------------------------------------------------------- |
|  version  | Shows the current version                                              |
|  migrate  | Migrates all revisions which are located in the `migrations` directory |
| unmigrate | Reversing applied migrations                                           |

### Extra information

The `migrate` and `unmigrate` both support arguments.

They support:

- `all`: Migrating / unmigrating all revisions
- `<revision id>`: Migrating / unmigrating a specific revision
- `<revision id> <revision id>`: Migrating / unmigrating multiple specific revisions

## How to use

1. Create a directory called `migrations`
2. Create your first migration with the following pattern `id_name_of_my_migration.sh`
   1. ID is an integer
   2. The name is up to you for identifying what the migration does
3. Declare the functions `migrateUp` and `migrateDown`
4. Fill both functions with the commands you would like to run
5. Run the `migrate` command
6. Be happy!

## Basic migration file

Here is an example for a migration file

```bash
function migrateUp() {
    echo "Migrating up"
}

function migrateDown() {
    echo "Migrating down
}
```
