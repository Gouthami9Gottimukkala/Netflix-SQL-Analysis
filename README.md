# Netflix Dataset Analysis: Movies & Series with SQL

![](https://github.com/Gouthami9Gottimukkala/netflix_sql_project/blob/main/Emblem.png)

This repository contains SQL queries and scripts for analyzing the Netflix dataset using MySQL.
The dataset includes information about Movies and TV Shows such as titles, directors, cast, countries, release years, ratings, durations, genres, and descriptions.

## 📌 Project Overview
The goal of this project is to perform SQL-based analysis of Netflix content to gain insights on:
- 📊 Content counts by type (Movies vs TV Shows)
- 🔖 Most common ratings
- 📅 Release trends by year and country
- 🌍 Top countries producing Netflix content
- ⏱️ Longest Movies and TV Shows (by duration/seasons)
- 🎬 Director and cast-based queries
- 🎭 Genre distributions
- ✅ Categorization of content based on keywords
- ⚠️ Identification of missing metadata (e.g., shows without directors)

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Dataset Description

The dataset is imported into a MySQL table named `netflix` with the following schema:

| Column      | Description                               |
| ----------- | --------------------------------------- |
| show_id     | Unique ID for each Netflix show/movie   |
| type        | Type of content: 'Movie' or 'TV Show'   |
| title       | Title of the movie or show               |
| director    | Director(s) name(s), comma-separated     |
| cast        | Cast members, comma-separated             |
| country     | Country or countries of production       |
| date_added  | Date show was added to Netflix            |
| release_year| Year the content was released             |
| rating      | Content rating (e.g., PG-13, TV-MA)      |
| duration    | Duration (e.g., '90 min' for movies, '2 Seasons' for TV shows) |
| listed_in   | Genres/categories, comma-separated       |
| description | Brief summary or description of content  |

## ⚙️ Usage Instructions
1. **Create the database and table**
 Run the provided SQL script:  
   ```sql
   SOURCE netflix_queries.sql;
2. **Load Data**
The script uses LOAD DATA INFILE to import the dataset (netflix.csv).
Make sure the file path in the query matches your MySQL environment.
3. **Run Queries**
The script includes queries such as:
- Count Movies vs TV Shows
- Most common ratings per type
- Movies released in a specific year
- Top countries by content count (with multi-country handling)
- Longest Movies & TV Shows
- Shows by specific directors
- Genre distribution analysis
- Categorization of content as Good or Bad
- Missing metadata checks (e.g., no director)

## 🌟 Example Query Highlights

- Top 5 countries with most content → Uses recursive CTEs to split multiple countries.
- Longest Movie/TV Show → Parses and casts durations to find maximum values.
- Director-based filtering → Handles comma-separated lists of multiple directors.
- Genre distribution analysis → Splits multi-genre entries for accurate counts.
- Content categorization → Classifies as Good or Bad based on keywords in descriptions.

## 📝 Findings and Conclusion

- Content Distribution: The dataset contains a diverse range of Movies and TV Shows across multiple genres and ratings.
- Common Ratings: The most frequent ratings (e.g., TV-MA, TV-14) highlight the target audience age groups on Netflix.
- Geographical Insights: Analysis shows top content-producing countries, with India being a significant contributor to Netflix’s library.
- Content Categorization: Keyword-based classification provides an overview of the nature of content (e.g., action/violence vs. family-friendly).
  ### 📌 Conclusion:
SQL-based analysis of the Netflix dataset reveals important trends in content distribution, audience targeting, geographical reach, and genre diversity. These insights can be further enhanced with visualization tools or extended datasets

## 📋 Requirements
- MySQL Server 8.0+ (required for recursive CTEs)
- Permission to use LOAD DATA INFILE for CSV import
- Basic SQL knowledge

## 📂 File Structure  

- **netflix.csv** → Dataset file  
- **Emblem.png** → Logo file  
- **netflix_queries.sql** → SQL schema + queries  
- **README.md** → Documentation  

## 👤 Author

GOUTHAMI GOTTIMUKKALA

✨ Feel free to explore, fork, and contribute! 🚀

