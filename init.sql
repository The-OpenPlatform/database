CREATE TABLE IF NOT EXISTS messages (
    id SERIAL PRIMARY KEY,
    message TEXT NOT NULL
);

INSERT INTO messages (message) VALUES
('Hello from DB'),
('PostgreSQL is awesome!'),
('This is a test message.'),
('Another message for testing.');
