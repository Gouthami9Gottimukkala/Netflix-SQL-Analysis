-- Create the database

CREATE DATABASE netflix_schema;

-- Switch to the database

USE netflix_schema;

-- Create table called netflix

CREATE TABLE netflix (
    show_id VARCHAR(10),       -- unique ID for each show (e.g., 's1', 's2')
    type TEXT,                 -- whether it is a 'Movie' or 'TV Show'
    title TEXT,                -- title of the movie/show
    director TEXT,             -- director's name(s), may be NULL
    cast TEXT,                 -- cast list (actors/actresses)
    country TEXT,              -- country where it was produced
    date_added TEXT,           -- date when it was added to Netflix (stored as text, e.g., 'September 24, 2021')
    release_year INT,          -- year of release (numeric)
    rating TEXT,               -- content rating (e.g., 'PG-13', 'TV-MA')
    duration TEXT,             -- runtime (e.g., '90 min', '2 Seasons')
    listed_in TEXT,            -- genre categories (comma-separated)
    description TEXT           -- short summary of the show/movie
);

-- Load data from the CSV file into the table

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/netflix.csv'
INTO TABLE netflix                         -- target table name
CHARACTER SET utf8mb4                      -- ensures Unicode characters (like movie names, symbols) are read correctly
FIELDS TERMINATED BY ','                   -- values in the CSV are separated by commas
ENCLOSED BY '"'                            -- text values are wrapped in double quotes
LINES TERMINATED BY '\n'                   -- each row in the CSV ends with a newline
IGNORE 1 LINES                             -- skip the header row (column names)
(show_id, type, title, director, cast, country, 
 date_added, release_year, rating, duration, 
 listed_in, description);                  -- map CSV columns to table columns
 
-- Show all rows and columns from the netflix table
SELECT * FROM netflix;
