-- +migrate Up

CREATE TABLE IF NOT EXISTS auth.refresh_tokens (
    id          UUID DEFAULT uuidv7() PRIMARY KEY,
    user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    token_hash  TEXT NOT NULL,

    user_agent  TEXT,
    ip_address  INET,

    expires_at  TIMESTAMPTZ NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    revoked_at  TIMESTAMPTZ
);

-- Поиск активных токенов пользователя: WHERE user_id = $1 AND revoked_at IS NULL
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_user_id
    ON auth.refresh_tokens (user_id);

-- Верификация токена по хешу при каждом /refresh: WHERE token_hash = $1
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_token_hash
    ON auth.refresh_tokens (token_hash);

-- +migrate Down

DROP TABLE IF EXISTS auth.refresh_tokens;
