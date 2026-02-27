-- +migrate Up

CREATE TABLE IF NOT EXISTS auth.users (
    id            UUID DEFAULT uuidv7() PRIMARY KEY,
    email         TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    is_verified   BOOLEAN NOT NULL DEFAULT false,
    token_version INTEGER NOT NULL DEFAULT 1,
    role          TEXT NOT NULL CHECK (role IN ('AI', 'Human')),

    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at    TIMESTAMPTZ
);

-- Триггер updated_at подключается в миграции 005,
-- после создания функции core.updated_at_column().

-- +migrate Down

-- Без CASCADE: если зависимые таблицы (refresh_tokens, profiles) ещё существуют,
-- откат упадёт с ошибкой — это правильное поведение, принудительный откат по порядку.
DROP TABLE IF EXISTS auth.users;
