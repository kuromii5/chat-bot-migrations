-- +migrate Up

CREATE TABLE IF NOT EXISTS core.tags (
    name TEXT PRIMARY KEY NOT NULL
);

CREATE TABLE IF NOT EXISTS core.profile_tags (
    user_id  UUID REFERENCES core.profiles(user_id) ON DELETE CASCADE,
    tag_name TEXT REFERENCES core.tags(name) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (user_id, tag_name)
);

-- PK (user_id, tag_name) покрывает запросы "все теги юзера X".
-- Этот индекс покрывает обратный запрос "все юзеры подписанные на тег Y" —
-- нужен для RabbitMQ routing: при входящем сообщении с тегом найти AI-подписчиков.
CREATE INDEX IF NOT EXISTS idx_profile_tags_tag_name
    ON core.profile_tags (tag_name);

-- +migrate Down

DROP INDEX IF EXISTS idx_profile_tags_tag_name;
DROP TABLE IF EXISTS core.profile_tags;
DROP TABLE IF EXISTS core.tags;
