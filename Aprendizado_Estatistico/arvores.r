
R version 4.4.2 (2024-10-31 ucrt) -- "Pile of Leaves"
Copyright (C) 2024 The R Foundation for Statistical Computing
Platform: x86_64-w64-mingw32/x64

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

> tree
Error: object 'tree' not found
> library tree
Error: unexpected symbol in "library tree"
> library $tree
Error in library$tree : object of type 'closure' is not subsettable
> library(RandomFlorest)
Error in library(RandomFlorest) : 
  there is no package called ‘RandomFlorest’
> library(RandomForest)
Error in library(RandomForest) : 
  there is no package called ‘RandomForest’
> library(Random Forest)
Error: unexpected symbol in "library(Random Forest"
> data()
> packets.install(randomForest)
Error in packets.install(randomForest) : 
  could not find function "packets.install"
> install.packages("tree")
Installing package into ‘C:/Users/Nimer/AppData/Local/R/win-library/4.4’
(as ‘lib’ is unspecified)
--- Please select a CRAN mirror for use in this session ---
trying URL 'https://cran-r.c3sl.ufpr.br/bin/windows/contrib/4.4/tree_1.0-44.zip'
Content type 'application/zip' length 161318 bytes (157 KB)
downloaded 157 KB

package ‘tree’ successfully unpacked and MD5 sums checked

The downloaded binary packages are in
        C:\Users\Nimer\AppData\Local\Temp\RtmpsrRPpV\downloaded_packages
> libary(tree)
Error in libary(tree) : could not find function "libary"
> library(tree)
> dados = data(Boston)
Warning message:
In data(Boston) : data set ‘Boston’ not found
> library(MASS)

> dados = Boston
> head(dados)
     crim zn indus chas   nox    rm  age    dis rad tax ptratio  black lstat medv
1 0.00632 18  2.31    0 0.538 6.575 65.2 4.0900   1 296    15.3 396.90  4.98 24.0
2 0.02731  0  7.07    0 0.469 6.421 78.9 4.9671   2 242    17.8 396.90  9.14 21.6
3 0.02729  0  7.07    0 0.469 7.185 61.1 4.9671   2 242    17.8 392.83  4.03 34.7
4 0.03237  0  2.18    0 0.458 6.998 45.8 6.0622   3 222    18.7 394.63  2.94 33.4
5 0.06905  0  2.18    0 0.458 7.147 54.2 6.0622   3 222    18.7 396.90  5.33 36.2
6 0.02985  0  2.18    0 0.458 6.430 58.7 6.0622   3 222    18.7 394.12  5.21 28.7
> ?Boston
starting httpd help server ... done
> set.seed(42)
> train = sample(1:nrows(Boston), nrow(Boston)/2)
Error in nrows(Boston) : could not find function "nrows"
> train = sample(1:nrow(Boston), nrow(Boston)/2)
> modelo_1 = tree(medv ~., data=dados, subset=train)
> summary(modelo_1)

Regression tree:
tree(formula = medv ~ ., data = dados, subset = train)
Variables actually used in tree construction:
[1] "rm"    "lstat" "dis"   "nox"  
Number of terminal nodes:  10 
Residual mean deviance:  16.67 = 4051 / 243 
Distribution of residuals:
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
-22.04000  -2.02900  -0.02258   0.00000   1.64000  13.97000 
> plot(modelo_1)
> text(modelo_1)
Error in text.default(xy$x[ind], xy$y[ind] + 0.5 * charht, rows[ind],  : 
  plot.new has not been called yet
> plot(modelo_1)
> text(modelo_1)
> cv.boston=cv.tree(modelo_1)
> plot(cv.boston$size, cv.boston$dev, type="b")
> modelo_podado = prune.tree(modelo_1, best=4)
> plot(modelo_podado)
> text(modelo_podado, pretty=0)
> yhat = predict(modelo_podado, newdata=Boston[-data,])
Error in -data : invalid argument to unary operator
> yhat = predict(modelo_1, newdata=Boston[-data,])
Error in -data : invalid argument to unary operator
> yhat = predict(modelo_podado, newdata=Boston[-train,])
> boston.test=Boston[-train, "medv"]
> REQM = sqrt(mean((yhat - boston.test)^2)) 
> REQM
[1] 5.764351
> #Bagging
> install.packages("randomForest")
Installing package into ‘C:/Users/Nimer/AppData/Local/R/win-library/4.4’
(as ‘lib’ is unspecified)
trying URL 'https://cran-r.c3sl.ufpr.br/bin/windows/contrib/4.4/randomForest_4.7-1.2.zip'
Content type 'application/zip' length 225905 bytes (220 KB)
downloaded 220 KB

package ‘randomForest’ successfully unpacked and MD5 sums checked

The downloaded binary packages are in
        C:\Users\Nimer\AppData\Local\Temp\RtmpsrRPpV\downloaded_packages
> library(randomForest)
randomForest 4.7-1.2
Type rfNews() to see new features/changes/bug fixes.
> modelo_bag = randomforest( medv ~ ., data=Boston, subset=train, mtry=13, importance=TRUE, ntree = 100)
Error in randomforest(medv ~ ., data = Boston, subset = train, mtry = 13,  : 
  could not find function "randomforest"
> modelo_bag = randomForest( medv ~ ., data=Boston, subset=train, mtry=13, importance=TRUE, ntree = 100)
> modelo_bag

Call:
 randomForest(formula = medv ~ ., data = Boston, mtry = 13, importance = TRUE,      ntree = 100, subset = train) 
               Type of random forest: regression
                     Number of trees: 100
No. of variables tried at each split: 13

          Mean of squared residuals: 17.26391
                    % Var explained: 81.17
> #AValiando o modelo 
> yhat.bag = predict(modelo_bag, newdata=Boston[-train ,])
> REQM_bag = SQrt(mean((yhat.bag - boston.test) ^ 2))
Error in SQrt(mean((yhat.bag - boston.test)^2)) : 
  could not find function "SQrt"
> REQM_bag = sqrt(mean((yhat.bag - boston.test) ^ 2))
> REQM_bag
[1] 3.111675
> #Random Forest
> modelo_rf = randomForest(medv ~ ., data=Boston, subset=train, mtry=4, importance=TRUE)
> yhat.rf = predict(modelo_rf, newdata=Boston[-train, ]
+ )
> REQM_rf = sqrt(mean(yhat.rf-boston.test)^ 2))
Error: unexpected ')' in "REQM_rf = sqrt(mean(yhat.rf-boston.test)^ 2))"
> REQM_rf = sqrt(mean((yhat.rf-boston.test)^ 2))
> REQM_rf
[1] 3.085285
> importance_rf = importance(modelo_rf)
> importance_rf
          %IncMSE IncNodePurity
crim    12.172904    1292.29380
zn       2.366611      83.58851
indus    9.690139    1247.01099
chas     2.285066      87.12669
nox     16.679898    1656.89864
rm      30.502691    6795.91163
age     12.920314     932.57703
dis     12.903297    1524.25252
rad      5.442807     206.57186
tax      7.698715     505.64074
ptratio 12.602270    1256.40629
black    7.553892     516.98412
lstat   24.889311    6640.21925
> varImpPlot(modelo_rf)
> save.image("C:\\Users\\Nimer\\Downloads\\arvores")
> 
