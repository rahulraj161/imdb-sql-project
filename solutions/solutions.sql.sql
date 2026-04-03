USE imdb;

-- Q1. Find the total number of rows in each table of the schema?
SELECT TABLE_NAME,table_rows
FROM information_schema. tables
WHERE TABLE_SCHEMA = 'imdb';

-- Q2. Which columns in the movie table have null values?
SELECT
SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_nulls,
SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_nulls,
SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_nulls,
SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_nulls,
SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_nulls,
SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_nulls,
SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_nulls,
SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_nulls
 FROM movie;

-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
SELECT year,COUNT(id) AS no_of_movies
FROM movie
GROUP BY  year;
SELECT MONTH(date_published) AS month_num , COUNT(id) AS no_of_movies
FROM movie
GROUP BY MONTH(date_published)
ORDER BY no_of_movies DESC;

-- -- Q4. How many movies were produced in the USA or India in the year 2019??
SELECT COUNT(*) AS total_movies
FROM movie
WHERE country LIKE '%USA%' OR country LIKE '%india%'
AND year = 2019;

-- Q5. Find the unique list of the genres present in the data set?
SELECT DISTINCT genre FROM genre;

-- Q6.Which genre had the highest number of movies produced overall?
SELECT genre,COUNT(*) AS total_movies
FROM genre
GROUP BY genre
ORDER BY total_movies DESC
LIMIT 1;

-- Q7. How many movies belong to only one genre?
WITH genre_summary AS (
SELECT movie_id,COUNT(genre) AS no_of_geners
FROM genre
GROUP BY movie_id
HAVING COUNT(genre) = 1)
SELECT COUNT(*) FROM genre_summary; 

-- Q8.What is the average duration of movies in each genre? 
SELECT genre ,AVG(duration) AS average_duration
FROM genre AS g
INNER JOIN movie AS m
ON m.id = g.movie_id
GROUP BY genre;

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
WITH movie_summary AS (
SELECT genre,COUNT(*) AS movie_count ,
RANK() OVER(ORDER BY COUNT(*) DESC ) AS rn
FROM genre 
GROUP BY genre)
SELECT * FROM movie_summary
WHERE genre = 'thriller';

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
SELECT MAX(avg_rating) AS mix_avg_rating,MIN(avg_rating) AS min_avg_rating,
MAX(total_votes) AS max_total_votes,MIN(total_votes) AS min_total_votes,
MAX(median_rating) AS max_median_rating,MIN(median_rating) AS min_median_rating
FROM ratings;

-- Q11. Which are the top 10 movies based on average rating?
WITH top_10_movies AS  (
SELECT title,avg_rating,
RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
)
SELECT * FROM top_10_movies
WHERE movie_rank <= 10;

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
SELECT median_rating,COUNT(movie_id) AS movie_count
 from ratings
 GROUP BY median_rating
 ORDER BY movie_count  DESC;
 
-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
WITH production_house_summary AS (
SELECT production_company,COUNT(id) AS movie_count,
RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_company_rank
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
WHERE avg_rating > 8
AND production_company IS NOT NULL
GROUP BY production_company
)
SELECT * FROM production_house_summary 
WHERE prod_company_rank =1;

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
SELECT genre,COUNT(g.movie_id) AS movie_count
FROM genre AS g
INNER JOIN movie AS m
ON g.movie_id = m.id
INNER JOIN ratings AS r
ON m.id = r.movie_id
WHERE year = 2017
AND MONTH(date_published) = 03
AND country LIKE '%USA%'
AND total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC;

-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
SELECT title,genre,avg_rating-- ,COUNT(g.movie_id) AS movie_count
FROM genre AS g
INNER JOIN movie AS m
ON g.movie_id = m.id
INNER JOIN ratings AS r
ON m.id = r.movie_id
WHERE title LIKE 'The%'
AND avg_rating > 8;

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
SELECT COUNT(*) AS movie_count
FROM movie 	AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
WHERE date_published BETWEEN '2018-04-01' AND '2019-04-01'
AND median_rating = 8;
USE imdb;
SHOW VARIABLES LIKE 'sql_mode';
SET GLOBAL sql_mode='';
-- Q17. Do German movies get more votes than Italian movies? 
WITH languages_summary AS (
SELECT languages, SUM(total_votes) AS total_votes FROM movie m  
JOIN ratings r ON m.id=r.movie_id
WHERE languages LIKE '%German%'
UNION
SELECT languages, SUM(total_votes) AS total_votes FROM movie m  
JOIN ratings r ON m.id=r.movie_id
WHERE languages LIKE '%Italian%'), highest_total_votes AS 
(SELECT * FROM languages_summary
ORDER BY total_votes DESC
LIMIT 1)
SELECT IF(languages LIKE '%GERMAN%','Yes','No') AS final_result 
FROM highest_total_votes;

-- Q18. Which columns in the names table have null values??
SELECT
SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) as id_null_count,
SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_null_count,
SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_null_count,
SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_null_count,
SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_null_count
FROM names;
USE imdb;
-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
WITH genre_summary AS (
SELECT genre,COUNT(m.id) AS movie_count
FROM genre AS g
INNER JOIN movie AS m
ON m.id = g.movie_id
INNER JOIN ratings AS r
ON r.movie_id = m.id
WHERE avg_rating > 8
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 3),
director_summary AS (
SELECT n.name AS director_name,COUNT(m.id) AS movie_count,
RANK() OVER(ORDER BY COUNT(m.id) DESC) AS rn
FROM genre AS g
INNER JOIN movie AS m
ON m.id = g.movie_id
INNER JOIN ratings AS r
ON r.movie_id = m.id
INNER JOIN director_mapping AS dm
ON dm.movie_id = m.id
INNER JOIN names AS n
ON n.id = dm.name_id
WHERE avg_rating > 8
AND genre IN (SELECT genre FROM genre_summary)
GROUP BY n.name)
SELECT * FROM director_summary
WHERE rn <=2;

 -- Q20. Who are the top two actors whose movies have a median rating >= 8?
WITH actor_summary AS (
SELECT n.name AS actor_name, COUNT(m.id) AS movie_count, 
RANK() OVER(ORDER BY COUNT(m.id) DESC) AS actor_rank
FROM movie m
JOIN ratings r ON m.id=r.movie_id
JOIN role_mapping rm ON m.id=rm.movie_id
JOIN names n ON n.id=rm.name_id
WHERE median_rating>=8
AND category='actor'
GROUP BY n.name)
SELECT actor_name, movie_count FROM actor_summary
WHERE actor_rank<=2;


-- Q21. Which are the top three production houses based on the number of votes received by their movies?
WITH top_three_prod_houses AS (	
SELECT production_company,SUM(total_votes) AS total_votes,
RANK() OVER(ORDER BY SUM(total_votes) DESC) AS rn
FROM movie AS m 
INNER JOIN ratings AS r
ON m.id = r.movie_id
GROUP BY production_company)
SELECT * FROM top_three_prod_houses 
WHERE rn <=3;

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
SELECT n.name AS actor_name, SUM(total_votes) AS total_votes, 
COUNT(m.id) AS movie_count,
SUM((avg_rating * total_votes))/(SUM(total_votes)) AS actor_avg_rating,
RANK() OVER(ORDER BY SUM((avg_rating * total_votes))/(SUM(total_votes)) DESC) AS actor_rank
FROM movie m
JOIN ratings r ON m.id=r.movie_id
JOIN role_mapping rm ON m.id=rm.movie_id
JOIN names n ON n.id=rm.name_id
WHERE category='actor'
AND country LIKE '%India%'
GROUP BY n.name
HAVING COUNT(m.id)>=5;

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
WITH actress_summary AS (
SELECT n.name AS actress_name, SUM(total_votes) AS total_votes, 
COUNT(m.id) AS movie_count,
SUM((avg_rating * total_votes))/(SUM(total_votes)) AS actress_avg_rating,
RANK() OVER(ORDER BY SUM((avg_rating * total_votes))/(SUM(total_votes)) DESC) AS actress_rank
FROM movie m
JOIN ratings r ON m.id=r.movie_id
JOIN role_mapping rm ON m.id=rm.movie_id
JOIN names n ON n.id=rm.name_id
WHERE category='actress'
AND country LIKE '%India%'
AND languages LIKE '%Hindi%'
GROUP BY n.name
HAVING COUNT(m.id)>=3)
SELECT * FROM actress_summary
WHERE actress_rank<=5;

/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
SELECT *, 
CASE 
	WHEN avg_rating>8 THEN 'Superhit Movie'
    WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit Movie'
    WHEN avg_rating BETWEEN 5 and 7 THEN 'One-time-watch Movie'
    ELSE 'Flop Movie'
END AS movie_result
FROM movie m
JOIN ratings r ON m.id=r.movie_id
JOIN genre g ON g.movie_id=m.id
WHERE genre='Thriller';

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
SELECT genre, AVG(duration) AS avg_duration,
SUM(AVG(duration)) OVER(ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_duration,
AVG(AVG(duration)) OVER(ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS moving_avg_duration 
FROM movie m
JOIN genre g ON g.movie_id=m.id
GROUP BY genre;

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)
WITH top_three_genres AS (
SELECT genre, COUNT(m.id) AS movie_count FROM movie m
JOIN ratings r ON m.id=r.movie_id
JOIN genre g ON m.id=g.movie_id
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 3), gross_summary AS (
SELECT genre, year, title AS movie_name, 
CAST(REPLACE(REPLACE(IFNULL(worlwide_gross_income,0),'$',''),'INR','') AS DECIMAL(20)) 
AS worldwide_gross_income,
RANK() OVER(PARTITION BY Year ORDER BY 
CAST(REPLACE(REPLACE(IFNULL(worlwide_gross_income,0),'$',''),'INR','') AS DECIMAL(20)) DESC) 
AS movie_rank
FROM movie m
JOIN genre g ON g.movie_id=m.id
WHERE genre IN (SELECT genre FROM top_three_genres))
SELECT * FROM gross_summary
WHERE movie_rank<=5;

USE imdb;
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
WITH production_summary AS (
SELECT production_company,COUNT(m.id) AS movie_count,
RANK() OVER(ORDER BY COUNT(m.id) DESC) AS prod_com_rank
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
WHERE median_rating >= 8
AND POSITION(',' IN languages)>0
AND production_company IS NOT NULL
GROUP BY production_company)
SELECT * FROM production_summary
WHERE prod_com_rank <= 2;

-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
WITH actress_summary AS (
SELECT n.name AS actress_name,SUM(total_votes) AS total_votes,COUNT(m.id) AS movie_count,
SUM((avg_rating * total_votes))/SUM(total_votes) AS actress_avg_rating,
RANK() OVER(ORDER BY COUNT(m.id) DESC ) AS actress_rank
FROM movie AS m
INNER JOIN role_mapping AS rm
ON m.id=rm.movie_id
INNER JOIN genre AS g
ON g.movie_id = m.id
INNER JOIN ratings AS r
ON m.id = r.movie_id
INNER JOIN names AS n
ON n.id = rm.name_id
WHERE avg_rating > 8
AND genre = 'Drama'
AND category = 'actress'
GROUP BY n.name)
SELECT *  FROM actress_summary
WHERE actress_rank <=3;

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations*/
WITH director_summary AS (
SELECT dm.name_id AS Director_id,n.name AS Director_Name,m.id AS movie_id,
date_published,
LEAD(date_published) OVER(PARTITION BY dm.name_id ORDER BY date_published) AS next_publish_date,
avg_rating,total_votes,duration
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
INNER JOIN director_mapping AS dm
ON m.id = dm.movie_id
INNER JOIN names AS n
ON n.id = dm.name_id),
direc_summary AS (
SELECT Director_id,Director_Name,COUNT(movie_id) AS Director_id,Director_Name,
SUM(DATEDIFF(next_publish_date,date_published))/COUNT(movie_id)-1 AS avg_inter_movie_days,
SUM((avg_rating * total_votes))/SUM(total_votes) AS directors_avg_rating,
SUM(total_votes) AS Total_votes,MIN(avg_rating)  AS min_rating,
MAX(avg_rating) AS max_rating,SUM(duration) AS total_duration,
RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS rn
 FROM director_summary
 GROUP BY Director_id,Director_Name)
 -- ORDER BY COUNT(movie_id) DESC;
SELECT Director_id,Director_Name,Director_id,Director_Name

 FROM direc_summary 
WHERE rn <= 9 




















