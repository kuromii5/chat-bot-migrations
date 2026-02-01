-- +migrate Up

CREATE TABLE IF NOT EXISTS core.tags (
    id    SERIAL PRIMARY KEY,
    name  TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS core.profile_tags (
    user_id UUID REFERENCES core.profiles(user_id) ON DELETE CASCADE,
    tag_id  INTEGER REFERENCES core.tags(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, tag_id)
);

-- +migrate Down

DROP TABLE IF EXISTS core.profile_tags CASCADE;
DROP TABLE IF EXISTS core.tags CASCADE;