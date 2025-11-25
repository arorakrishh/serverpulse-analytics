CREATE DATABASE event_message_db;
CREATE USER demouser WITH PASSWORD 'demouser';
GRANT ALL PRIVILEGES ON DATABASE event_message_db TO demouser;
\c event_message_db
GRANT ALL ON SCHEMA public TO demouser;
