#!/bin/sh
set -e

# Substitute schema/role names from the environment into the sql-migrate
# config and into every migration file. The variables (${ADMIN_USER},
# ${APP_USER}, ${READONLY_USER}) are provided by the migrator Job.
envsubst < dbconfig.yml > dbconfig.yml.tmp && mv dbconfig.yml.tmp dbconfig.yml

for f in migrations/*.sql; do
    if [ -f "$f" ]; then
        envsubst < "$f" > "$f.tmp" && mv "$f.tmp" "$f"
    fi
done

sql-migrate up -env=chat-bot-db
