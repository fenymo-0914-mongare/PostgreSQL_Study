#!/bin/bash

USER="postgres"
DB="first_database"
FOLDER="/f/ReactJS/Postgresql_Study"


# PostgreSQL tools (quoted to handle spaces in Program Files)
PSQL="/c/Program Files/PostgreSQL/18/bin/psql.exe"
PG_DUMP="/c/Program Files/PostgreSQL/18/bin/pg_dump.exe"

export PGPASSWORD="MyDataBase1234"  

echo "Exporting schema + data per table..."

# Query all tables in public schema
TABLES=$("$PSQL" -U "$USER" -d "$DB" -t -c "SELECT tablename FROM pg_tables WHERE schemaname='public';")

for T in $TABLES; do
  echo "Processing $T..."

  # Schema file per table
  SCHEMA_FILE="$FOLDER/${T}_schema.sql"
  > "$SCHEMA_FILE"

  "$PSQL" -U "$USER" -d "$DB" -t -c "
    SELECT 'CREATE TABLE ' || '$T' || E' (\n' ||
           string_agg('    ' || column_name || ' ' || data_type, E',\n') ||
           E'\n);\n'
    FROM information_schema.columns
    WHERE table_schema='public' AND table_name='$T';
  " >> "$SCHEMA_FILE"

  # Add constraints
  "$PSQL" -U "$USER" -d "$DB" -t -c "
    SELECT pg_get_constraintdef(oid) || ';'
    FROM pg_constraint
    WHERE conrelid = '$T'::regclass;
  " >> "$SCHEMA_FILE"

  # Add indexes
  "$PSQL" -U "$USER" -d "$DB" -t -c "
    SELECT indexdef || ';'
    FROM pg_indexes
    WHERE schemaname='public' AND tablename='$T';
  " >> "$SCHEMA_FILE"

    # Data file per table
    DATA_FILE="$FOLDER/${T}_data.sql"
    > "$DATA_FILE"

    "$PG_DUMP" -U "$USER" -d "$DB" --data-only --column-inserts --table="$T" |
    grep '^INSERT' |
    awk '
    {
        split($0, a, " VALUES ")
        if (!seen++) {
            print a[1]
            print "VALUES"
        } else {
            printf ",\n"
        }

        val = a[2]
        sub(/;$/, "", val)
        printf "%s", val
    }
    END {
        if (seen) print ";"
    }
    ' > "$DATA_FILE"

    echo "Staging files..."
    git add "$SCHEMA_FILE" "$DATA_FILE"

    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

    echo "Committing..."
    git commit -m "Database backup - $TIMESTAMP"

    echo "Pushing to GitHub..."
    git push origin main
done

echo "Done pushin the files to the repository."
