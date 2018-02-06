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
