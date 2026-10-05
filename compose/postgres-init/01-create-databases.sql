-- Runs once, when the pgdata volume is first initialised. Migrations / Hibernate create the
-- tables, but each service expects its database to already exist.
CREATE DATABASE viscord_auth;
CREATE DATABASE viscord_user;
CREATE DATABASE viscord_guild;
CREATE DATABASE viscord_message;
