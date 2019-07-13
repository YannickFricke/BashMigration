# Bash-Migration

## Table of contents

- [Bash-Migration](#Bash-Migration)
  - [Table of contents](#Table-of-contents)
  - [About the project](#About-the-project)
    - [Features](#Features)
  - [Requirements](#Requirements)
    - [Notices](#Notices)
  - [Commands](#Commands)
    - [Extra information](#Extra-information)
      - [Notice](#Notice)
  - [How to use](#How-to-use)
  - [Basic migration file](#Basic-migration-file)
    - [Information](#Information)
  - [How to use in a project](#How-to-use-in-a-project)
  - [Extended usage](#Extended-usage)

## About the project

Bash-Migration is a tool for applying / reversing migrations to a server.

### Features

- Apply migrations to your server
- Reverse migrations you don't need anymore
- Automatic rollback when an action failed
- Possibility to apply or reverse specific migrations
- Uses a semaphore to prevent running in parallel

## Requirements

| Name   | Version | Description                                   |
| :----- | :-----: | :-------------------------------------------- |
| bash   |  5.0.3  | For running the BashMigration script          |
| grep   |   3.3   | For extracting informations from the filename |
| SQLite | 3.28.0  | As persistent data store                      |

### Notices

- Instead of bash you could also use zsh (tested with version 5.5.1)
- The `sqlite3` command must be available in the command line.

## Commands

|   Name    | Description                                                            |
| :-------: | :--------------------------------------------------------------------- |
|  migrate  | Migrates all revisions which are located in the `migrations` directory |
| unmigrate | Reversing applied migrations                                           |
|   list    | List the status of all migrations                                      |
|  version  | Shows the current version                                              |

### Extra information

The `migrate` and `unmigrate` both support arguments.

They support:

- `all`: Migrating / unmigrating all revisions
- `<revision id>`: Migrating / unmigrating a specific revision
- `<revision id> <revision id>`: Migrating / unmigrating multiple specific revisions

#### Notice

By default the `all` argument is used.

## How to use

1. Create a directory called `migrations`
2. Create your first migration with the following pattern `id_name_of_my_migration.sh`
   1. ID is an integer
   2. The name is up to you for identifying what the migration does
3. Declare the functions `migrateUp` and `migrateDown` (see below for an example)
4. Fill both functions with the commands you would like to run
5. Run the `migrate` command
6. Be happy!

## Basic migration file

Here is an example for a migration file

```bash
function migrateUp() {
    echo "Migrating up"

    return 0
}

function migrateDown() {
    echo "Migrating down"

    return 0
}
```

### Information

When one of the functions returns the value `1`, the action will be considered as unsuccessful and we rollback.

## How to use in a project

- Initialize a git repository in an empty directory
- Add BashMigration as submodule: `git submodule add -b master https://github.com/YannickFricke/BashMigration.git BashMigration`
- Create the `migrations` directory
- Create your first migration file (as described)
- Start the script with `./BashMigration/BashMigration.sh migrate`

You could also create a `Makefile` for easier usage.

## Extended usage

Take a look into the [wiki](https://github.com/YannickFricke/BashMigration/wiki) for additional informations.
