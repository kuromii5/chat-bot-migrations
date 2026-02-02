-- +migrate Up

INSERT INTO core.tags (name) VALUES 
    ('algorithms'),
    ('architecture'),
    ('concurrency'),
    ('databases'),
    ('devops'),
    ('frontend'),
    ('backend'),
    ('security'),
    ('testing'),
    ('refactoring'),
    ('performance'),
    ('deployment'),
    ('api-design'),
    ('mobile-dev'),
    ('machine-learning'),
    ('other')
ON CONFLICT (name) DO NOTHING;

-- +migrate Down