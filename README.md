# K-means Clustering in R
Example k-means clustering analysis of red wine in R

Sample dataset on red wine samples used from [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/wine+quality).

```R
df <- read.csv("winequality-red.csv", sep=";", header=TRUE)

head(df, n=2)
```
|fixed.acidity | volatile.acidity | citric.acid | residual.sugar| chlorides | free.sulfur.dioxide |total.sulfur.dioxide | density |  pH | sulphates | alcohol | quality |
|--------------|------------------|-------------|---------------|-----------|-------|------|--------|------|----|---|---|
|1 |         7.4  |           0.70    |    0.00        |    1.9   |  0.076 | 11 | 34 | 0.9978 | 3.51 | 0.56 | 9.4 | 5 |
|2 |          7.8 |           0.88  |      0.00   |         2.6 |    0.098 | 25 | 67 | 0.9968 | 3.20 | 0.68 | 9.8 | 5 |



### Data Preparation
To prepare the dataset for clustering, we center and scale the columns using [`scale(x, center = TRUE, scale = TRUE)`](https://www.rdocumentation.org/packages/base/versions/3.4.3/topics/scale), where x is a matrix or dataframe.
```R
df_scaled <- scale(df[-1])

head(df_scaled, n=2)
```
|volatile.acidity | citric.acid | residual.sugar | chlorides | free.sulfur.dioxide | total.sulfur.dioxide | density | pH | sulphates | alcohol | quality |
|--|--|--|--|--|--|--|--|--|--|--|
| 0.9615758 | -1.391037 | -0.45307667 | -0.24363047 | -0.46604672 | -0.3790141 | 0.55809987 | 1.2882399 | -0.57902538 | -0.9599458 | -0.7875763|
| 1.9668271 | -1.391037 | 0.04340257 | 0.22380518 | 0.87236532 | 0.6241680 | 0.02825193 | -0.7197081 | 0.12891007 | -0.5845942 | -0.7875763|



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
![wss_plot](https://github.com/trevorwitter/Clustering/blob/master/wss_plot.jpg)



### Deterimine optimal number of clusters
[`NbClust()`](https://www.rdocumentation.org/packages/NbClust/versions/3.0/topics/NbClust) is used to determine the best clustering scheme from the different results obtained by varying all combinations of number of clusters and distance methods.

```R
library("NbClust")
set.seed(1234)
nc <- NbClust(df_scaled, min.nc=2, max.nc=15, method="kmeans")
```
![n_clusters](https://github.com/trevorwitter/Clustering/blob/master/n_clusters.jpg)

In these two figures, Dindex refers to the [Dunn index](https://en.wikipedia.org/wiki/Dunn_index). Higher Dunn index values indicate better clustering. 

Optimal number of clusters is determined as the number of clusters selected by the highest number of criteria. This can be visualized as a barplot:
```R
barplot(table(nc$Best.n[1,]),
          xlab="Numer of Clusters", ylab="Number of Criteria",
          main="Number of Clusters Chosen by 26 Criteria")
```
![n_clusters_bar](https://github.com/trevorwitter/Clustering/blob/master/n_clusters_bar_plot.jpg)



### K-means cluster analysis
[`kmeans()`](https://www.rdocumentation.org/packages/stats/versions/3.4.3/topics/kmeans) is used to obtain the final clustering solution.  
```R
set.seed(1234)
fit.km <- kmeans(df, 2, nstart=25)
```
`fit.km$size` returns the number of items in each cluster
```R
fit.km$size
```
`[1] 1179  420`

`fit.km$centers` returns the central value for each cluster
```R
fit.km$centers
```
|fixed.acidity | volatile.acidity | citric.acid | residual.sugar| chlorides | free.sulfur.dioxide |total.sulfur.dioxide | density |  pH | sulphates | alcohol | quality |
|--|--|--|--|--|--|--|--|--|--|--|--|
| 8.424258 | 0.5193342 | 0.2665394 | 2.394275 | 0.08544614 | 12.37193 | 30.34436 | 0.9966768 | 3.315522 | 0.6565310 | 10.54022 | 5.724343|
| 8.025952 | 0.5516429 | 0.2834286 | 2.944524 | 0.09313810 | 25.70833 | 91.72857 | 0.9969427 | 3.298738 | 0.6626905 | 10.09389 | 5.388095|

As the centroids are quantified using the scaled data, the [`aggregate()`](https://www.rdocumentation.org/packages/stats/versions/3.4.3/topics/aggregate) function is used with the determined cluster memberships to quantify variable means for each cluster:
```R
aggregate(df[-1], by=list(cluster=fit.km$cluster),mean)
```
|cluster |fixed.acidity | volatile.acidity | citric.acid | residual.sugar| chlorides | free.sulfur.dioxide |total.sulfur.dioxide | density |  pH | sulphates | alcohol | quality |
|--|--|--|--|--|--|--|--|--|--|--|--|--|
| 1 | 0.5193342 | 0.2665394 | 2.394275 | 0.08544614 | 12.37193 | 30.34436 | 0.9966768 | 3.315522 | 0.6565310 | 10.54022 | 5.724343 |
| 2 | 0.5516429 | 0.2834286 | 2.944524 | 0.09313810 | 25.70833 | 91.72857 | 0.9969427 | 3.298738 | 0.6626905 | 10.09389 | 5.388095 |

Inspired by Chapter 16 in [R in Action](https://www.manning.com/books/r-in-action) by Robert I. Kabacoff. 
