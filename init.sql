DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = 'admin') THEN
        CREATE USER admin WITH PASSWORD 'password';
    END IF;
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = 'app') THEN
        CREATE USER app WITH PASSWORD 'password';
    END IF;
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = 'readonly') THEN
        CREATE USER readonly WITH PASSWORD 'password';
    END IF;
END
$$;

GRANT CONNECT ON DATABASE chat_bot_db TO admin, app, readonly;
GRANT CREATE ON DATABASE chat_bot_db TO admin;

CREATE SCHEMA IF NOT EXISTS core;
ALTER SCHEMA core OWNER TO admin;
ALTER USER admin SET search_path TO core, public;