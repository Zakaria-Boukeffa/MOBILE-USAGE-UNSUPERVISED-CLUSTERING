# MOBILE-USERS-CLUSTERING

This is an unsupervised clustering project in **R**, using **k-means** to segment mobile users based on their daily usage statistics.

## Dataset

**Smartphone Usage and Behavioral Dataset** by **Bhadra Mohit** (Kaggle):  
https://www.kaggle.com/datasets/bhadramohit/smartphone-usage-and-behavioral-dataset

### Columns
- `User_ID`: unique user identifier  
- `Age`: 18–60  
- `Gender`: Male/Female  
- `Total_App_Usage_Hours`: total hours spent on apps/day  
- `Daily_Screen_Time_Hours`: total daily screen time (hours)  
- `Number_of_Apps_Used`: number of distinct apps used/day  
- `Social_Media_Usage_Hours`: hours on social media/day  
- `Productivity_App_Usage_Hours`: hours on productivity apps/day  
- `Gaming_App_Usage_Hours`: hours on gaming apps/day  
- `Location`: city/region  

## Applied steps

1. **Data preparation**
   - Keep only **quantitative continuous variables** .
   - Standardize variables.

2. **Exploratory Data Analysis (EDA)**
   - Summary statistic.
   - Visual inspection using boxplots and histograms.

3. **Choose the number of clusters (k)**
   - Compute **R² = betweenSS / totalSS** for `k = 2..10`.
   - Select **k** using the elbow method.

4. **Clustering**
   - Run k-means with the selected **k**.
   - Save cluster assignments and key outputs.

5. **Profiling**
   - Bind cluster labels to the original dataset.
   - Describe clusters by comparing:
     - **Quantitative variables**: cluster means vs overall means.
     - **Categorical variables**: distribution of `Gender` and `Location` across clusters.
