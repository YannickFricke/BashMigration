INIT_SQL=$(cat <<SQL
    create table migrations
    (
        id text
            constraint migrations_pk
            primary key,
        name text,
        migrated INTEGER default 0 not null
    );

    create unique index migrations_id_uindex
        on migrations (id);

    create unique index migrations_name_uindex
        on migrations (name);
SQL
)
