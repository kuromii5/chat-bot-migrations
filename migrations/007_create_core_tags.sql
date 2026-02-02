-- +migrate Up

CREATE TABLE IF NOT EXISTS core.tags (
    name TEXT PRIMARY KEY NOT NULL
);

CREATE TABLE IF NOT EXISTS core.profile_tags (
    user_id UUID REFERENCES core.profiles(user_id) ON DELETE CASCADE,
    tag_name TEXT REFERENCES core.tags(name) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (user_id, tag_name)
);

-- +migrate Down

DROP TABLE IF EXISTS core.profile_tags CASCADE;
DROP TABLE IF EXISTS core.tags CASCADE;