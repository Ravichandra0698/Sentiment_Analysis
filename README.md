🐦 Sentiment Analysis of Political Tweets (Trump vs. Clinton - 2016 Election)
This project performs a comprehensive sentiment analysis on tweets from the 2016 U.S. presidential candidates: Donald Trump and Hillary Clinton. It explores tweet patterns, performs text preprocessing, and leverages lexicons to uncover emotional tones and sentiment differences using R.

📁 Dataset
tweets.csv: Contains over 6,400 tweets from the 2016 campaign period

Fields include: id, handle, text, is_retweet, original_author, time, language, retweet_count, favorite_count, location info, and more.

📦 Libraries Used
This project is developed in R using the following libraries:

tidyverse, knitr, readr, dplyr, tidyr, ggplot2, stringr, tm, NLP, wordcloud, tidytext, lubridate, 
reshape2, gridExtra, scales, ggrepel, kableExtra, broom, topicmodels
🔍 Project Overview
1. Loading and Cleaning Data
Parses tweet timestamps.

Cleans the text field by removing URLs, newline characters, punctuation, numbers, stopwords, and user names.

2. Language Detection
Filters for English tweets.

Identifies and examines non-English content.

3. Tweet Authorship
Differentiates between original tweets and retweets.

Analyzes who the candidates most often retweeted.

4. Corpus Creation and Preprocessing
Separate corpora for Trump and Clinton.

Cleaning operations:

Convert to lowercase

Remove numbers, punctuation, English stopwords

Strip whitespace

Remove candidate names

5. Term Frequency Analysis
Identifies most used terms.

Visualized using:

Line plots

Word clouds

Term frequency comparisons

6. Sentiment Analysis
📘 Lexicons Used:
Bing: Positive/Negative binary sentiment

NRC: 8 basic emotions + positive/negative

📊 Visualizations:
Bar charts of most frequent positive/negative words.

Polar plots for emotional sentiment distribution (via NRC lexicon).

📊 Example Visualizations
Top Words: Line plots for most used terms per candidate.

Wordclouds: Top 100 words excluding candidate names.

Comparison Cloud: Clinton vs Trump word frequencies.

Emotion Distribution: NRC-based sentiment wheel for both candidates.

💡 Key Insights
Trump authored more original tweets than Clinton.

Clear linguistic and emotional differences are seen through term frequency and NRC-based emotion analysis.

Emotion wheels show how each candidate’s tone differs across sentiments like "fear", "trust", "anger", and "joy".

🚀 How to Run
Clone the repository

Open in RStudio

Install required packages (if not already)

Run sentiment_analysis.R (or follow the .Rmd file if you create one)

📌 Notes
Preprocessing is crucial to clean and normalize political text data.

Lexicon-based sentiment analysis provides intuitive insights but may miss contextual nuances.

This can be extended using machine learning or deep learning models for more robust sentiment classification.
