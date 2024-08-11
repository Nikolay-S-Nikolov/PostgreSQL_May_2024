DROP TABLE IF EXISTS countries CASCADE;

CREATE TABLE countries
(
    id        SERIAL PRIMARY KEY,
    name      VARCHAR(40) NOT NULL UNIQUE,
    continent VARCHAR(40) NOT NULL,
    currency  VARCHAR(5)
);

DROP TABLE IF EXISTS categories CASCADE;

CREATE TABLE categories
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

DROP TABLE IF EXISTS actors CASCADE;

CREATE TABLE actors
(
    id         SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    birthdate  DATE        NOT NULL,
    height     INT,
    awards     INT         NOT NULL DEFAULT 0 CHECK (awards >= 0),
    country_id INT         NOT NULL,
    CONSTRAINT fk_actors_countries
        FOREIGN KEY (country_id)
            REFERENCES countries (id)
            ON UPDATE CASCADE ON DELETE CASCADE

);

DROP TABLE IF EXISTS productions_info CASCADE;

CREATE TABLE productions_info
(
    id            SERIAL PRIMARY KEY,
    rating        NUMERIC(4, 2) NOT NULL,
    duration      INT           NOT NULL CHECK (duration > 0),
    budget        NUMERIC(10, 2),
    release_date  DATE          NOT NULL,
    has_subtitles BOOLEAN       NOT NULL DEFAULT FALSE,
    synopsis      TEXT
);

DROP TABLE IF EXISTS productions CASCADE;

CREATE TABLE productions
(
    id                 SERIAL PRIMARY KEY,
    title              VARCHAR(70) NOT NULL UNIQUE,
    country_id         INT         NOT NULL,
    production_info_id INT         NOT NULL UNIQUE,
    CONSTRAINT fk_productions_countries
        FOREIGN KEY (country_id)
            REFERENCES countries (id)
            ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_productions_productions_info
        FOREIGN KEY (production_info_id)
            REFERENCES productions_info (id)
            ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS productions_actors CASCADE;

CREATE TABLE productions_actors
(
    production_id INT NOT NULL,
    actor_id      INT NOT NULL,
    PRIMARY KEY (production_id, actor_id),
    CONSTRAINT fk_productions_actors_productions
        FOREIGN KEY (production_id)
            REFERENCES productions (id)
            ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_productions_actors_actors
        FOREIGN KEY (actor_id)
            REFERENCES actors (id)
            ON UPDATE CASCADE ON DELETE CASCADE

);

DROP TABLE IF EXISTS categories_productions CASCADE;

CREATE TABLE categories_productions
(
    category_id   INT NOT NULL,
    production_id INT NOT NULL,
    PRIMARY KEY (category_id, production_id),
    CONSTRAINT fk_categories_productions_categories
        FOREIGN KEY (category_id)
            REFERENCES categories (id)
            ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_categories_productions_productions
        FOREIGN KEY (production_id)
            REFERENCES productions (id)
            ON UPDATE CASCADE ON DELETE CASCADE
);

