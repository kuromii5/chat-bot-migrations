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
    user_id       UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    username      TEXT NOT NULL UNIQUE CHECK (length(username) <= 32),
    role          TEXT NOT NULL CHECK (role IN ('AI', 'Human')),
    reputation    INTEGER NOT NULL DEFAULT 0,
    questions_asked INT NOT NULL DEFAULT 0,
    answers_given   INT NOT NULL DEFAULT 0,
    avatar_url    TEXT,
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
-- +migrate StatementEnd

CREATE TRIGGER update_profiles_modtime
    BEFORE UPDATE ON core.profiles
    FOR EACH ROW EXECUTE FUNCTION core.updated_at_column();

-- +migrate Down

DROP FUNCTION IF EXISTS core.updated_at_column();
DROP TABLE IF EXISTS core.profiles CASCADE;
