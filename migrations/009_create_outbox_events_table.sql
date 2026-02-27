-- +migrate Up

CREATE TABLE IF NOT EXISTS core.outbox_events (
    id             UUID        NOT NULL DEFAULT uuidv7() PRIMARY KEY,
    aggregate_type TEXT        NOT NULL,
    aggregate_id   UUID        NOT NULL,
    event_type     TEXT        NOT NULL,

    -- Полезная нагрузка (fat event — полный снимок объекта на момент события)
    payload        JSONB       NOT NULL,


    status         TEXT        NOT NULL DEFAULT 'pending'
                               CHECK (status IN ('pending', 'processing', 'published', 'failed', 'dead')),

    -- Retry-механика с экспоненциальным backoff
    attempts       INT         NOT NULL DEFAULT 0,
    max_attempts   INT         NOT NULL DEFAULT 5,
    next_retry_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_error     TEXT,

    -- Аудит
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    published_at   TIMESTAMPTZ
);

-- Основной индекс relay-воркера: только pending события, упорядоченные по времени готовности.
-- Partial index — published/failed/dead строки в него не попадают,
-- поэтому индекс остаётся компактным даже при большом объёме исторических данных.
CREATE INDEX IF NOT EXISTS idx_outbox_pending
    ON core.outbox_events (next_retry_at)
    WHERE status = 'pending';

-- Вспомогательный индекс: поиск всех событий конкретного объекта.
-- Используется при дебаге ("почему сообщение X не было доставлено?")
-- и для гарантии порядка обработки событий одного агрегата.
CREATE INDEX IF NOT EXISTS idx_outbox_aggregate
    ON core.outbox_events (aggregate_type, aggregate_id);

-- +migrate Down

DROP INDEX IF EXISTS idx_outbox_aggregate;
DROP INDEX IF EXISTS idx_outbox_pending;
DROP TABLE IF EXISTS core.outbox_events;
