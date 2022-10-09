#!/usr/bin/env bash
set -x
set -eo pipefail

if ! [ -x "$(command -v psql)" ]; then
    echo >&2 "Error: psql is not installed."
    exit 1
fi

if ! [ -x "$(command -v sqlx)" ]; then
    echo >&2 "Error: sqlx is not installed."
    echo >&2 "Use:"
    echo >&2 " cargo install --version='~0.6' sqlx-cli \
--no-default-features --features rustls,postgres"
    echo >&2 "to install it."
    exit 1
fi

source .env
if [[ -z "${SKIP_DOCKER}" ]]; then
    docker-compose up -d postgres
else
    echo >&2 "Skipping upping postgres"
fi

export PGPASSWORD=$POSTGRES_PASSWORD
until psql -h "localhost" -U "${POSTGRES_USER}" -p "${POSTGRES_PORT}" -d "postgres" -c '\q'; do
    echo >&2 "Postgres is still unavailable - sleeping"
    sleep 1
done

echo >&2 "Postgres is up and running on port ${POSTGRES_PORT} - running migrations now!"
DATABASE_URL=postgres://${POSTGRES_USER}:${PGPASSWORD}@localhost:${POSTGRES_PORT}/${POSTGRES_DB}
export DATABASE_URL
sqlx database create
sqlx migrate run
echo >&2 "Postgres has been migrated, ready to go!"
