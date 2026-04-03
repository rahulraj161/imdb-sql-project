# IMDB SQL Analysis Project 🎬

## 📌 About the Project

In this project, I worked on an IMDB movie dataset to analyze different aspects like movie trends, ratings, genres, and people involved in movies.

The main goal was to solve real business questions that can help a company (RSVP Movies) make better decisions for releasing movies globally.

---

## 🗂 Dataset

The dataset contains multiple tables such as:

* movies
* genres
* ratings
* names (actors/directors)
* role mappings

---

## 🛠 Tools & Concepts Used

* SQL (MySQL)
* Joins
* Group By & Aggregations
* Subqueries
* CTEs
* Window Functions

---

## 📊 What I Did

* Analyzed how many movies are released each year and month
* Found top genres based on number of movies
* Identified highest rated movies
* Analyzed directors and actors performance
* Answered multiple business-related questions using SQL

---

## ⭐ Highlights

* Solved 20+ SQL questions
* Worked on a real-world type business problem
* Practiced advanced SQL concepts like window functions and CTEs

---

## 📁 Project Structure

* dataset → contains SQL file to create tables and insert data
* questions → contains all problem questions
* solutions → contains SQL queries for each question
* problem_statement → project description file

---

## 🚀 How to Run

1. Import the dataset SQL file into MySQL
2. Run the queries from questions.sql
3. Check the solutions.sql for answers

---

## 💡 What I Learned

* Writing complex SQL queries
* Understanding business problems using data
* Using joins and window functions effectively
* Structuring a complete SQL project

---
## 📊 Key Insights

- Drama is one of the most frequent genres  
- Some directors consistently produce high-rated movies  
- Movie releases are higher in certain months  
- Ratings show most movies fall in average range  

---

## 🧪 Sample Query

Find top 5 highest rated movies:

SELECT movie_name, avg_rating  
FROM movies  
ORDER BY avg_rating DESC  
LIMIT 5;

---
## 📸 Sample Output

![Sample Output](sample_output.png)

--- 

## 🧠 Example Insight

One of the queries identifies top-rated movies using aggregation and sorting.  
This helps in understanding which movies performed best based on audience ratings.

This project helped me improve my SQL skills and understand how data is used in real-world scenarios.
