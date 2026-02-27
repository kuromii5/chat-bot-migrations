-- +migrate Up

-- +migrate StatementBegin
CREATE OR REPLACE FUNCTION core.updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- +migrate StatementEnd

-- +migrate StatementBegin
CREATE TABLE IF NOT EXISTS core.profiles (
    user_id    UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    username   TEXT NOT NULL UNIQUE CHECK (length(username) <= 32),
    avatar_url TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
-- +migrate StatementEnd

-- +migrate StatementBegin
DROP TRIGGER IF EXISTS update_profiles_modtime ON core.profiles;
CREATE TRIGGER update_profiles_modtime
    BEFORE UPDATE ON core.profiles
    FOR EACH ROW EXECUTE FUNCTION core.updated_at_column();
-- +migrate StatementEnd

-- auth.users.updated_at существует с миграции 003, но функция была ещё не определена.
-- Подключаем триггер здесь, сразу после создания функции.
-- +migrate StatementBegin
DROP TRIGGER IF EXISTS update_users_modtime ON auth.users;
CREATE TRIGGER update_users_modtime
    BEFORE UPDATE ON auth.users
    FOR EACH ROW EXECUTE FUNCTION core.updated_at_column();
-- +migrate StatementEnd

-- +migrate Down

DROP TRIGGER IF EXISTS update_users_modtime ON auth.users;
DROP TRIGGER IF EXISTS update_profiles_modtime ON core.profiles;
DROP TABLE IF EXISTS core.profiles;
DROP FUNCTION IF EXISTS core.updated_at_column();
