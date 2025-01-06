> url = "https://raw.githubusercontent.com/HammadN98/pos-Inteligencia-Artificial-e-Computacional/refs/heads/main/Aprendizado_Estatistico/dados/dados_regressao_simples.csv"
> dados = read.csv(url)
> head(dados)
  consumo temperatura dias pureza producao
1     240          25   24     91      100
2     236          31   21     90       95
3     270          45   24     88      110
4     274          60   25     87       88
5     301          65   25     91       94
6     316          72   26     94       99
> names(dados)
[1] "consumo"     "temperatura" "dias"        "pureza"      "producao"   
> summary(dados)
    consumo       temperatura         dias           pureza     
 Min.   :236.0   Min.   :25.00   Min.   :21.00   Min.   :86.00  
 1st Qu.:265.5   1st Qu.:43.25   1st Qu.:24.00   1st Qu.:87.75  
 Median :275.0   Median :60.00   Median :25.00   Median :89.50  
 Mean   :277.1   Mean   :57.08   Mean   :24.33   Mean   :89.33  
 3rd Qu.:297.0   3rd Qu.:72.75   3rd Qu.:25.00   3rd Qu.:91.00  
 Max.   :316.0   Max.   :84.00   Max.   :26.00   Max.   :94.00  
    producao     
 Min.   : 88.00  
 1st Qu.: 95.75  
 Median : 98.50  
 Mean   : 99.33  
 3rd Qu.:101.25  
 Max.   :110.00  
> pairs(dados, col = 2, pch = 19)
> modelo1 = lm(consumo ~ temperatura + dias + pureza + producao, data=dados)
> modelo1

Call:
lm(formula = consumo ~ temperatura + dias + pureza + producao, 
    data = dados)

Coefficients:
(Intercept)  temperatura         dias       pureza     producao  
  -123.1312       0.7573       7.5188       2.4831      -0.4811  

> summary(modelo1)

Call:
lm(formula = consumo ~ temperatura + dias + pureza + producao, 
    data = dados)

Residuals:
    Min      1Q  Median      3Q     Max 
-14.098  -9.778   1.767   6.798  13.016 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)  
(Intercept) -123.1312   157.2561  -0.783    0.459  
temperatura    0.7573     0.2791   2.713    0.030 *
dias           7.5188     4.0101   1.875    0.103  
pureza         2.4831     1.8094   1.372    0.212  
producao      -0.4811     0.5552  -0.867    0.415  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 11.79 on 7 degrees of freedom
Multiple R-squared:  0.852,     Adjusted R-squared:  0.7675 
F-statistic: 10.08 on 4 and 7 DF,  p-value: 0.00496

> modelo2 = lm(consumo ~ temperatura, data=dados)
> summary(modelo2)

Call:
lm(formula = consumo ~ temperatura, data = dados)

Residuals:
    Min      1Q  Median      3Q     Max 
-28.195  -6.597  -2.140   7.827  23.838 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) 219.3800    14.2655  15.378 2.75e-08 ***
temperatura   1.0109     0.2376   4.254  0.00168 ** 
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 15.3 on 10 degrees of freedom
Multiple R-squared:  0.6441,    Adjusted R-squared:  0.6085 
F-statistic:  18.1 on 1 and 10 DF,  p-value: 0.001679

> prever = data.frame(temperatura = 51)
> predict(modelo2, prever)
       1 
270.9339 
> prever2 = data.frame(temperatura = 25)
> predict(modelo2, prever2)
       1 
244.6515 
> save.image("C:\\Users\\Nimer\\Downloads\\regressao_simples")
> 
