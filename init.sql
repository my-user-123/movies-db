-- init.sql

CREATE DATABASE IF NOT EXISTS streaming;
USE streaming;

-- Lookup tables
CREATE TABLE IF NOT EXISTS languages (
    language_id INT PRIMARY KEY,
    language_name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS genres (
    genre_id INT PRIMARY KEY,
    genre_name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS productioncompanies (
    company_id INT PRIMARY KEY,
    company_name VARCHAR(255),
    country VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY,
    username VARCHAR(100),
    signup_date DATE,
    country VARCHAR(100)
);

-- Main tables
CREATE TABLE IF NOT EXISTS movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR(255),
    release_year YEAR,
    duration_minutes INT,
    language_id INT,
    budget BIGINT,
    revenue BIGINT,
    FOREIGN KEY (language_id) REFERENCES languages(language_id)
);

-- M2M tables
CREATE TABLE IF NOT EXISTS moviegenres (
    movie_id INT,
    genre_id INT,
    PRIMARY KEY(movie_id, genre_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

CREATE TABLE IF NOT EXISTS moviecompanies (
    movie_id INT,
    company_id INT,
    PRIMARY KEY(movie_id, company_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    FOREIGN KEY (company_id) REFERENCES productioncompanies(company_id)
);

-- Fact table
CREATE TABLE IF NOT EXISTS ratings (
    rating_id INT PRIMARY KEY,
    movie_id INT,
    user_id INT,
    rating_value DECIMAL(3,1),
    rating_date DATE,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Load data
-- Assumes CSVs are in /var/lib/mysql-files/

LOAD DATA INFILE '/var/lib/mysql-files/languages.csv'
INTO TABLE languages
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(language_id, language_name);

LOAD DATA INFILE '/var/lib/mysql-files/genres.csv'
INTO TABLE genres
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(genre_id, genre_name);

LOAD DATA INFILE '/var/lib/mysql-files/production_companies.csv'
INTO TABLE productioncompanies
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(company_id, company_name, country);

LOAD DATA INFILE '/var/lib/mysql-files/users.csv'
INTO TABLE users
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(user_id, username, signup_date, country);

LOAD DATA INFILE '/var/lib/mysql-files/movies.csv'
INTO TABLE movies
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(movie_id, title, release_year, duration_minutes, language_id, budget, revenue);

LOAD DATA INFILE '/var/lib/mysql-files/movie_genres.csv'
INTO TABLE moviegenres
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(movie_id, genre_id);

LOAD DATA INFILE '/var/lib/mysql-files/movie_companies.csv'
INTO TABLE moviecompanies
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(movie_id, company_id);

LOAD DATA INFILE '/var/lib/mysql-files/ratings.csv'
INTO TABLE ratings
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(rating_id, movie_id, user_id, rating_value, rating_date);
