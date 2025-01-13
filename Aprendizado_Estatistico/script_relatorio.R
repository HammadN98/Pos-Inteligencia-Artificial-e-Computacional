#Boston
library(MASS)
#Atribuido os dados
dados = Boston
#Explorar os dados
summary(dados)

#Dividin do os dados
set.seed(42)
install.package("caret")
library(caret)
train_index = createDataPartition(dados$medv, p = 0.75, list = FALSE)
train_data = dados[train_index, ]
test_data = dados[-train_index, ]