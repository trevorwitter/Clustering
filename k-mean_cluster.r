library("NbClust")

df <- read.csv("winequality-red.csv", sep=";", header=TRUE)

# Plots within groups sum of squares
wssplot <- function(data, nc=15, seed=1234){
               wss <- (nrow(data)-1)*sum(apply(data,2,var))
               for (i in 2:nc){
                    set.seed(seed)
                    wss[i] <- sum(kmeans(data, centers=i)$withinss)}
                plot(1:nc, wss, type="b", xlab="Number of Clusters",
                     ylab="Within groups sum of squares")}


# Center and scale data frame columns
df_scaled <- scale(df[-1])
head(df_scaled)

# Determine optimal number of columns 
wssplot(df_scaled)

set.seed(1234)
nc <- NbClust(df_scaled, min.nc=2, max.nc=15, method="kmeans")

# Optimal Number of clusters
barplot(table(nc$Best.n[1,]),
          xlab="Numer of Clusters", ylab="Number of Criteria",
          main="Number of Clusters Chosen by 26 Criteria")

# K-means cluster analysis
set.seed(1234)
fit.km <- kmeans(df, 3, nstart=25)

fit.km$size # Number of items in each cluster

fit.km$centers # returns central value for each cluster

aggregate(df[-1], by=list(cluster=fit.km$cluster),mean)
