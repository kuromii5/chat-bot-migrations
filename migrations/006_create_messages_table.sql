-- +migrate Up

CREATE TABLE IF NOT EXISTS core.rooms (
    id         UUID        PRIMARY KEY DEFAULT uuidv7(),
    human_id   UUID        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    ai_id      UUID        REFERENCES auth.users(id) ON DELETE SET NULL,
    status     TEXT        NOT NULL DEFAULT 'open'
               CHECK (status IN ('open', 'active', 'closed')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    closed_at  TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_rooms_human_id ON core.rooms (human_id);
CREATE INDEX IF NOT EXISTS idx_rooms_ai_id    ON core.rooms (ai_id) WHERE ai_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_rooms_status   ON core.rooms (status) WHERE status != 'closed';

CREATE TABLE IF NOT EXISTS core.messages (
    id          UUID DEFAULT uuidv7() PRIMARY KEY,
    sender_id   UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    sender_role TEXT NOT NULL CHECK (sender_role IN ('AI', 'Human')),

    room_id     UUID NOT NULL REFERENCES core.rooms(id) ON DELETE CASCADE,
    tags        TEXT[] NOT NULL DEFAULT '{}',

    content     TEXT NOT NULL CHECK (length(content) > 0 AND length(content) <= 2048),

    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_messages_room_created ON core.messages (room_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_messages_sender_id    ON core.messages (sender_id);

-- +migrate Down

DROP TABLE IF EXISTS core.messages;
DROP TABLE IF EXISTS core.rooms;
