-- +migrate Up

ALTER TABLE auth.users
    ADD COLUMN email_notifications_enabled BOOLEAN NOT NULL DEFAULT true;

CREATE SCHEMA IF NOT EXISTS notification;

CREATE TABLE IF NOT EXISTS notification.processed_events (
    event_id   UUID        PRIMARY KEY,
    processed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

GRANT USAGE ON SCHEMA notification TO ${APP_USER}, ${READONLY_USER};

GRANT SELECT, INSERT, UPDATE, DELETE
    ON ALL TABLES IN SCHEMA notification TO ${APP_USER};
GRANT SELECT ON ALL TABLES IN SCHEMA notification TO ${READONLY_USER};

ALTER DEFAULT PRIVILEGES IN SCHEMA notification
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO ${APP_USER};
ALTER DEFAULT PRIVILEGES IN SCHEMA notification
    GRANT SELECT ON TABLES TO ${READONLY_USER};

-- +migrate Down

DROP TABLE IF EXISTS notification.processed_events;
DROP SCHEMA IF EXISTS notification;

ALTER TABLE auth.users
    DROP COLUMN IF EXISTS email_notifications_enabled;
