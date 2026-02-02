-- +migrate Up

CREATE TABLE IF NOT EXISTS auth.refresh_tokens (
    id          UUID DEFAULT uuidv7() PRIMARY KEY,
    user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    token_hash  TEXT NOT NULL,

    user_agent  TEXT,
    ip_address  INET,

    is_revoked  BOOLEAN NOT NULL DEFAULT false,

    expires_at  TIMESTAMPTZ NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    revoked_at  TIMESTAMPTZ
);

-- +migrate Down

DROP TABLE IF EXISTS auth.refresh_tokens CASCADE;
