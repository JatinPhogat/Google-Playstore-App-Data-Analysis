# Google Play Store Apps Analysis 

## 📌 Project Overview
This project analyzes Google Play Store apps using R to gain insights into app categories, user ratings, reviews, and other key factors that influence app popularity and success. The dataset includes various attributes such as app name, category, rating, reviews, size, installs, type, price, and content rating.

## 📂 Dataset
The dataset used for this analysis is sourced from the Google Play Store and contains:
- **App** 🎮: Name of the application
- **Category** 📂: Category of the app
- **Rating** ⭐: User rating (out of 5)
- **Reviews** 💬: Number of reviews
- **Size** 📏: Size of the application
- **Installs** 📥: Number of installs
- **Type** 💲: Free or Paid
- **Price** 💰: Cost of the app
- **Content Rating** 🎯: Age group suitability

📥 **Download Dataset**: [Google Play Store Dataset](https://www.kaggle.com/datasets/lava18/google-play-store-apps)

## 🎯 Objectives
The key objectives of this analysis are:
- Understand app distribution across different categories.
- Analyze the relationship between ratings, reviews, and installs.
- Identify patterns in app pricing and popularity.
- Provide data-driven insights for app developers and businesses.

## 🛠️ Tools & Technologies
- **R Programming Language** 🖥️: Used for data manipulation, analysis, and visualization.
- **Libraries**:
  - `tidyverse` 📊 (for data manipulation and visualization)
  - `ggplot2` 📉 (for creating visualizations)
  - `dplyr` 🔍 (for data processing)
  - `readr` 📄 (for reading CSV files)

## 🏗️ Installation & Setup
1. Install R and RStudio (if not already installed).
2. Install required libraries using:
   ```r
   install.packages(c("tidyverse", "ggplot2", "dplyr", "readr"))
   ```
3. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/google-play-analysis.git
   ```
4. Load the dataset into R:
   ```r
   data <- read.csv("googleplaystore.csv")
   ```

## 📊 Analysis & Visualizations
- **App Category Distribution** 📌: Bar charts showing the number of apps in each category.
- **Rating vs. Installs** 🔗: Scatter plots to explore the correlation between ratings and installs.
- **Free vs. Paid Apps** 💲: Comparisons of popularity, ratings, and revenue.
- **Word Cloud** ☁️: Popular words in app names and descriptions.

## 🔍 Results & Insights
- Most apps fall under categories like **Games, Education, and Business**.
- Higher-rated apps tend to have more reviews and installs.
- Free apps dominate the store, but paid apps generally receive better ratings.

## 🚀 Future Improvements
- Perform sentiment analysis on user reviews.
- Use machine learning to predict app success based on features.
- Expand dataset to include newer apps and trends.
