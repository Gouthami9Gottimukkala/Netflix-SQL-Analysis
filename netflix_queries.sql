
-- Count how many records are present in the netflix table
SELECT COUNT(*) FROM netflix;

-- Analytical Questions to Explore Netflix Dataset (15 Tasks)

-- 1. Counting the number of Movies vs TV Shows
SELECT type, COUNT(*) AS count
FROM netflix
GROUP BY type;

-- 2. Finding the most common rating for movies and TV shows

SELECT t.type, t.rating, t.count_rating
FROM (
    SELECT 
        type, 
        rating, 
        COUNT(*) AS count_rating,
        ROW_NUMBER() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rn
    FROM netflix
    GROUP BY type, rating
) t
WHERE t.rn = 1;

-- 3. Listing all movies released in 2020
SELECT * 
FROM netflix
WHERE release_year = 2020 AND type = 'Movie';

-- 4. Top 5 countries with the most content

-- Step 1: Recursive CTE to split multiple countries in the "country" column into separate rows
WITH RECURSIVE country_split AS (
    -- Base case: take the first country before the first comma
    SELECT
        show_id,   -- unique ID of the show
        TRIM(SUBSTRING_INDEX(country, ',', 1)) AS country_trimmed,  -- extract first country
        SUBSTRING(country, LENGTH(SUBSTRING_INDEX(country, ',', 1)) + 2) AS rest  -- remaining countries (if any)
    FROM netflix
    WHERE country IS NOT NULL   -- ignore rows where country is NULL
    UNION ALL
    -- Recursive case: keep extracting the next country from the remaining string
    SELECT
        show_id,
        TRIM(SUBSTRING_INDEX(rest, ',', 1)),  -- extract the next country
        SUBSTRING(rest, LENGTH(SUBSTRING_INDEX(rest, ',', 1)) + 2)  -- update the "rest" string
    FROM country_split
    WHERE rest != ''   -- continue until no countries are left
)
-- Step 2: Aggregate the results
SELECT
    country_trimmed,        -- country name
    COUNT(*) AS total_content   -- number of shows from that country
FROM
    country_split
WHERE
    country_trimmed IS NOT NULL AND country_trimmed != ''   -- clean up null/empty values
GROUP BY
    country_trimmed   -- group by each country
ORDER BY
    total_content DESC   -- sort in descending order
LIMIT 5;   -- pick the top 5 countries

-- 6. Finding the movie with the longest duration on Netflix

SELECT * 
FROM netflix
WHERE type = 'Movie'    -- Step 1: Only consider Movies (exclude TV Shows)
  AND duration IS NOT NULL   -- Step 2: Ignore rows where duration is missing
ORDER BY 
  CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC  
  -- Step 3: The "duration" column is stored as text like '90 min' or '2 Seasons'.
  --   SUBSTRING_INDEX(duration, ' ', 1) → takes the number part before the first space (e.g., '90' from '90 min').
  --   CAST(... AS UNSIGNED) → converts that text number into an integer, so we can sort numerically.
  --   DESC → sort in descending order (longest movie first).
LIMIT 1;  		-- Step 4: Pick only the top 1 record (the longest movie).

-- 7. Finding the TV Show with the maximum number of seasons on Netflix

SELECT * 
FROM netflix
WHERE type = 'TV Show'       -- Step 1: Only consider TV Shows (exclude Movies)

  AND duration IS NOT NULL   -- Step 2: Ignore rows where duration is missing

ORDER BY 
  CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC  
  -- Step 3: The "duration" column for TV Shows looks like "3 Seasons" or "1 Season".
  --   SUBSTRING_INDEX(duration, ' ', 1) → takes the number before the first space (e.g., '3' from '3 Seasons').
  --   CAST(... AS UNSIGNED) → converts it into an integer so sorting works correctly.
  --   DESC → sort in descending order (most seasons first).

LIMIT 1;  				-- Step 4: Pick only the top 1 record (the TV Show with the most seasons).

-- 8. Finding the content added in the last 5 years

SELECT *
FROM netflix
WHERE 
    -- Convert 'date_added' to DATE format and check if it is within the last 5 years from today
    STR_TO_DATE(date_added, '%M %d, %Y') >= CURDATE() - INTERVAL 5 YEAR;

-- 9. All movies/TV shows by director 'Rajiv Chilaka'

-- Step 1: Create a derived table that splits the 'director' column into individual names
SELECT *
FROM (
    SELECT 
        netflix.*,  -- Include all original columns from the 'netflix' table
        -- Extract the nth director from the comma-separated 'director' field
        -- Example: If director = 'A, B, C', this extracts A, then B, then C
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(director, ',', numbers.n), ',', -1)) AS director_name
    FROM netflix
    -- Step 2: Create an inline numbers table (1 to 5) to simulate a loop
    -- This helps us extract up to 5 director names per row
    JOIN (
        SELECT 1 AS n UNION ALL
        SELECT 2 UNION ALL
        SELECT 3 UNION ALL
        SELECT 4 UNION ALL
        SELECT 5
    ) AS numbers
    -- Step 3: Filter out rows where 'numbers.n' exceeds the number of directors
    -- Count the number of commas in 'director' and add 1 to get total number of names
    ON numbers.n <= 1 + LENGTH(director) - LENGTH(REPLACE(director, ',', ''))
) AS expanded_directors
-- Step 4: Filter the results to only include rows where the extracted director is 'Rajiv Chilaka'
WHERE director_name = 'Rajiv Chilaka';

-- 10. TV shows with more than 5 seasons

SELECT *
FROM netflix
WHERE type = 'TV Show'
AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;

-- 11. Counting how many movies/TV shows are in each genre

SELECT genre_trimmed, COUNT(*) AS total_content
FROM (
    -- Extract individual genres from the comma-separated 'listed_in' column
    SELECT 
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', numbers.n), ',', -1)) AS genre_trimmed
    FROM netflix
    -- Generate a sequence of numbers from 1 to 5 to split up to 5 genres per row
    JOIN (
        SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
    ) AS numbers
    ON CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= numbers.n - 1  -- Limit extraction to the actual number of genres in each row
) AS genres
GROUP BY genre_trimmed             -- Group by genre and count how many times each appears
ORDER BY total_content DESC;       -- Sort the results in descending order of content count

-- 12. Fetching top 5 years with the most Netflix content released in India
SELECT release_year,
       COUNT(*) AS total_release,
       ROUND((COUNT(*) / (SELECT COUNT(*) FROM netflix WHERE country = 'India')) * 100, 2) AS avg_release_percentage
FROM netflix
WHERE country = 'India'
GROUP BY release_year
ORDER BY avg_release_percentage DESC
LIMIT 5;

-- 13. Fetching all movies that are documentaries

SELECT *
FROM netflix
WHERE type = 'Movie'
AND listed_in LIKE '%Documentaries%';

-- 14. Fetching all movies and TV shows that do not have a director assigned

SELECT *
FROM netflix
WHERE director IS NULL           -- Director column is NULL
   OR TRIM(director) = '';      -- Director column is empty or contains only spaces

-- 15. Fetching all movies or shows in which actor 'Salman Khan' appeared in the last 10 years

SELECT * FROM netflix
WHERE `cast` LIKE '%Salman Khan%' AND release_year >= YEAR(CURDATE()) - 10
ORDER BY release_year DESC;

-- 16. -- Categorizing Netflix content as 'Good' or 'Bad' based on keywords in the description
WITH cte AS (
    SELECT *,
        CASE WHEN LOWER(description) LIKE '%kill%' 
			 OR LOWER(description) LIKE '%violence%' THEN 'Bad'
             ELSE 'Good'
        END AS category
    FROM netflix
)
SELECT 
    category, 
    type, 
    COUNT(*) AS content_count
FROM cte
GROUP BY category, type
ORDER BY category, type;








