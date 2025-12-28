### Part 1: Data preparation

df <- read.csv("mobile_usage.csv", header = TRUE)

# Select quantitative continuous attributes since we are applying k-means
df2 <- df[, c(2, 4, 5, 6, 7, 8, 9)]

# Check means before scaling
apply(df2, 2, mean)

# Normalize the data (standardization) since we have different scales
df3 <- scale(df2)

### Part 2: Exploratory data analysis

# Statistics
summary(df2)

# Graphics: Boxplots
par(mfrow = c(3, 3), mar = c(0, 4, 2, 1))
for (i in 1:ncol(df2)) {
  boxplot(df2[, i],
          main = colnames(df2)[i])
}

# Graphics: Histograms
par(mfrow = c(3, 3), mar = c(4, 4, 2, 1))
for (i in 1:ncol(df2)) {
  hist(df2[, i],
       main = colnames(df2)[i],
       xlab = colnames(df2)[i])
}

par(mfrow = c(1, 1))

### Part 3 : Choice of the number of clusters ( k ) using R²

k.values <- 2:50
R2 <- numeric(length(k.values))

for (i in seq_along(k.values)) {
  km <- kmeans(df3, centers = k.values[i], nstart = 100)
  R2[i] <- km$betweenss / km$totss
}

plot(k.values,R2)
lines(k.values,R2)

# The R² curve shows an elbow around k = 4
resuclassif <- kmeans(df3,4,nstart=100)

# We choose K=4 with R2=24.2%


### Part 4 : Clustering results

# number of users per cluster 
resuclassif$size # 264 269 241 226

# Cluster membership for each user
resuclassif$cluster

# Between-cluster sum of squares
resuclassif$betweenss

# Within-cluster sum of squares (by cluster)
resuclassif$withinss

# Total within-cluster sum of squares
resuclassif$tot.withinss

# Total sum of squares
resuclassif$totss

### Part 5: Cluster description 

# Bind cluster labels to the original dataframe
group <- factor(resuclassif$cluster)
df_clustered <- cbind(df, group)
df_clustered <- df_clustered[order(df_clustered$group), ]

### Part 5: Cluster profiling

attach(df_clustered)

summary(lm(Total_App_Usage_Hours ~ group))$r.squared
summary(lm(Daily_Screen_Time_Hours ~ group))$r.squared
summary(lm(Number_of_Apps_Used ~ group))$r.squared
summary(lm(Social_Media_Usage_Hours ~ group))$r.squared
summary(lm(Productivity_App_Usage_Hours ~ group))$r.squared
summary(lm(Gaming_App_Usage_Hours ~ group))$r.squared
summary(lm(Age ~ group))$r.squared

aggregate(df2, by = list(group), mean)
prop.table(table(df_clustered$Gender, group), 2)

prop.table(table(df_clustered$Location, group), 2)

# no single variable strongly discriminates the clusters

mean_cluster <- apply(df2, 2, mean)
moy_list <- list()
for (v in colnames(df2)) {
  moy_list[[v]] <- tapply(df2[[v]], group, mean)
}
tabmoycomp <- cbind(do.call(rbind, moy_list), mean_cluster)
round(t(tabmoycomp), 2)

# Since all correlation ratios are below 50%, we cannot comment on individual variables
# We'll do it anyway for practice's sake (;

# Cluster 1: Lower app usage, fewer apps, high social media usage : Social oriented light users
# Cluster 2: Lower app usage, few apps, strong gaming orientation : Gamers 
# Cluster 3: High productivity, many apps, low social and gaming usage, older : Probably parents
# Cluster 4: Balanced usage close to the overall average : Average users


par(mfrow = c(2, 3))

boxplot(Total_App_Usage_Hours ~ group, main = "Total App Usage")
points(tapply(Total_App_Usage_Hours, group, mean), col = "red", pch = 19)

boxplot(Daily_Screen_Time_Hours ~ group, main = "Screen Time")
points(tapply(Daily_Screen_Time_Hours, group, mean), col = "red", pch = 19)

boxplot(Number_of_Apps_Used ~ group, main = "Number of Apps")
points(tapply(Number_of_Apps_Used, group, mean), col = "red", pch = 19)

boxplot(Social_Media_Usage_Hours ~ group, main = "Social Media")
points(tapply(Social_Media_Usage_Hours, group, mean), col = "red", pch = 19)

boxplot(Productivity_App_Usage_Hours ~ group, main = "Productivity")
points(tapply(Productivity_App_Usage_Hours, group, mean), col = "red", pch = 19)

boxplot(Gaming_App_Usage_Hours ~ group, main = "Gaming")
points(tapply(Gaming_App_Usage_Hours, group, mean), col = "red", pch = 19)

# Visualisation of users and there groups 
library(factoextra)
fviz_cluster(resuclassif,df2)
