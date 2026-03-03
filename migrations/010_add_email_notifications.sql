-- +migrate Up

ALTER TABLE auth.users
    ADD COLUMN email_notifications_enabled BOOLEAN NOT NULL DEFAULT true;

CREATE SCHEMA IF NOT EXISTS notification;

CREATE TABLE IF NOT EXISTS notification.processed_events (
    event_id   UUID        PRIMARY KEY,
    processed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- +migrate Down

DROP TABLE IF EXISTS notification.processed_events;
DROP SCHEMA IF EXISTS notification;

ALTER TABLE auth.users
    DROP COLUMN IF EXISTS email_notifications_enabled;
