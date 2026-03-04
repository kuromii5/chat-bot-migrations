-- +migrate Up
CREATE INDEX idx_messages_room_latest ON core.messages (room_id, created_at DESC);

-- +migrate Down
DROP INDEX IF EXISTS core.idx_messages_room_latest;
