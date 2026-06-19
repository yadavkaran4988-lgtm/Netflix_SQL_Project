create table netflix (
  show_id varchar (10),
  type varchar(20),
  title varchar(200),
  director varchar (208),
  casts varchar(1000),
  country varchar(100),
  date_added varchar(80),
  release_year int,
  rating varchar(10),
  duration varchar(150),
  listed_in varchar(150),
  description varchar (300)
);


---- 15 Business Problems

-- 1. Count the number of movies and TV shows

select	type, count(*) as total_content
from netflix 
group by type;

-- 2. find the most common ratings for Movies & TV shows

WITH rating_count AS (
    SELECT
        type,
        rating,
        ROW_NUMBER() OVER (
            PARTITION BY type
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM netflix
    GROUP BY type, rating
)

SELECT
    type,
    rating
FROM rating_count
WHERE rn = 1;

-- 3. list all movies released in a specific year

SELECT *FROM netflix
WHERE type = 'Movie'
AND release_year = 2020;

-- 4. Find the top 5 countries with the most content on netflix

SELECT
    country,
    COUNT(*) AS total_content
FROM netflix
WHERE country IS NOT NULL
  AND country <> ''
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;

-- 5. Identify the longest movie?

SELECT
    title,
    duration
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(REPLACE(duration, ' min', '') AS UNSIGNED) DESC
LIMIT 1;

-- 6. find content added in the last 5 years

SELECT
    title,
    type,
    date_added
FROM netflix
WHERE STR_TO_DATE(date_added, '%M %d, %Y')
      >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);
      
-- 7. find all the movies & TV shoes by rajeev chilaka
      
SELECT
    title,
    type,
    director
FROM netflix
WHERE director = 'Rajiv Chilaka';

 -- 8. List all tv shows with more than 5 seasons
 
 SELECT
    title,
    duration
FROM netflix
WHERE type = 'TV Show'
  AND CAST(REPLACE(duration, ' Seasons', '') AS UNSIGNED) > 5;
  
-- 9. Count the number of content items in each genre

SELECT
    listed_in,
    COUNT(*) AS total_content
FROM netflix
GROUP BY listed_in
ORDER BY total_content DESC;

-- 10. find the average release year for content produced in a specific country
  
SELECT
    ROUND(AVG(release_year), 2) AS avg_release_year
FROM netflix
WHERE country LIKE '%United States%';

-- 11. List all movies that are documentaries

SELECT *
FROM netflix
WHERE type = 'Movie'
AND listed_in LIKE '%Documentaries%';

-- 12. Find all content without a director

SELECT *
FROM netflix
WHERE director IS NULL
OR director = '';

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years

SELECT title, release_year
FROM netflix
WHERE type = 'Movie'
AND cast LIKE '%Salman Khan%'
AND release_year >= YEAR(CURDATE()) - 10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India

SELECT cast,
       COUNT(*) AS total_movies
FROM netflix
WHERE type = 'Movie'
AND country LIKE '%India%'
GROUP BY cast
ORDER BY total_movies DESC
LIMIT 10;

--- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
 
 SELECT
    CASE
        WHEN description LIKE '%kill%'
          OR description LIKE '%violence%'
        THEN 'Bad'
        ELSE 'Good'
    END AS category,
    COUNT(*) AS total_content
FROM netflix
GROUP BY category;

