# Clustering
Example k-means clustering in R

Sample dataset on red wine samples used from [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/wine+quality)

```R
df <- read.csv("winequality-red.csv", sep=";", header=TRUE)

head(df)

#fixed.acidity volatile.acidity citric.acid residual.sugar chlorides
#1           7.4             0.70        0.00            1.9     0.076
#2           7.8             0.88        0.00            2.6     0.098
#3           7.8             0.76        0.04            2.3     0.092
#4          11.2             0.28        0.56            1.9     0.075
#5           7.4             0.70        0.00            1.9     0.076
#6           7.4             0.66        0.00            1.8     0.075
#  free.sulfur.dioxide total.sulfur.dioxide density   pH sulphates alcohol
#1                  11                   34  0.9978 3.51      0.56     9.4
#2                  25                   67  0.9968 3.20      0.68     9.8
#3                  15                   54  0.9970 3.26      0.65     9.8
#4                  17                   60  0.9980 3.16      0.58     9.8
#5                  11                   34  0.9978 3.51      0.56     9.4
#6                  13                   40  0.9978 3.51      0.56     9.4
#  quality
#1       5
#2       5
#3       5
#4       6
#5       5
#6       5
```
### Data Preparation
To prepare the dataset for clustering, we center and scale the columns using [`scale(x, center = TRUE, scale = TRUE)`](https://www.rdocumentation.org/packages/base/versions/3.4.3/topics/scale), where x is a matrix or dataframe.
```R
df_scaled <- scale(df[-1])

head(df_scaled)

#volatile.acidity citric.acid residual.sugar   chlorides
#[1,]        0.9615758   -1.391037    -0.45307667 -0.24363047
#[2,]        1.9668271   -1.391037     0.04340257  0.22380518
#[3,]        1.2966596   -1.185699    -0.16937425  0.09632273
#[4,]       -1.3840105    1.483689    -0.45307667 -0.26487754
#[5,]        0.9615758   -1.391037    -0.45307667 -0.24363047
#[6,]        0.7381867   -1.391037    -0.52400227 -0.26487754
#     free.sulfur.dioxide total.sulfur.dioxide    density         pH   sulphates
#[1,]         -0.46604672           -0.3790141 0.55809987  1.2882399 -0.57902538
#[2,]          0.87236532            0.6241680 0.02825193 -0.7197081  0.12891007
#[3,]         -0.08364328            0.2289750 0.13422152 -0.3310730 -0.04807379
#[4,]          0.10755844            0.4113718 0.66406945 -0.9787982 -0.46103614
#[5,]         -0.46604672           -0.3790141 0.55809987  1.2882399 -0.57902538
#[6,]         -0.27484500           -0.1966174 0.55809987  1.2882399 -0.57902538
#        alcohol    quality
#[1,] -0.9599458 -0.7875763
#[2,] -0.5845942 -0.7875763
#[3,] -0.5845942 -0.7875763
#[4,] -0.5845942  0.4507074
#[5,] -0.9599458 -0.7875763
#[6,] -0.9599458 -0.7875763
```
### Determine Optimal Number of Columns

```R
wssplot <- function(data, nc=15, seed=1234){
               wss <- (nrow(data)-1)*sum(apply(data,2,var))
               for (i in 2:nc){
                    set.seed(seed)
                    wss[i] <- sum(kmeans(data, centers=i)$withinss)}
                plot(1:nc, wss, type="b", xlab="Number of Clusters",
                     ylab="Within groups sum of squares")}

wssplot(df_scaled)
```

```R
set.seed(1234)
nc <- NbClust(df_scaled, min.nc=2, max.nc=15, method="kmeans")

table(nc$Best.n[1,])

barplot(table(nc$Best.n[1,]),
          xlab="Numer of Clusters", ylab="Number of Criteria",
          main="Number of Clusters Chosen by 26 Criteria")
```
### Recalculate Centroids
```R
set.seed(1234)
fit.km <- kmeans(df, 3, nstart=25)

fit.km$size

fit.km$centers

aggregate(df[-1], by=list(cluster=fit.km$cluster),mean)
```
