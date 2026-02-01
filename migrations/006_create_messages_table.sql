-- +migrate Up

CREATE TABLE IF NOT EXISTS core.messages (
    id          UUID DEFAULT uuidv7() PRIMARY KEY,
    sender_id   UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    sender_role TEXT NOT NULL CHECK (sender_role IN ('AI', 'Human')),
    
    room_id     TEXT NOT NULL DEFAULT 'global',
    tags        TEXT[] NOT NULL DEFAULT '{}',
    
    content     TEXT NOT NULL CHECK (length(content) > 0 AND length(content) <= 2048),
    assigned_to UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_messages_room_created ON core.messages (room_id, created_at DESC);

-- +migrate Down

DROP TABLE IF EXISTS core.messages CASCADE;