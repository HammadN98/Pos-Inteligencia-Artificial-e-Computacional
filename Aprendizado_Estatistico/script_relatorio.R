#Bibliotecas
library(MASS)#Boston
install.packages("caret")
library(caret)
install.packages("glmnet")
library(glmnet)
install.packages("rpart.plot")
library(rpart.plot)

#Atribuido os dados
dados = Boston
#Explorar os dados
summary(dados)

#Dividin do os dados

set.seed(42)
train_index = createDataPartition(dados$medv, p = 0.75, list = FALSE)
train_data = dados[train_index, ]
test_data = dados[-train_index, ]
x_train <- as.matrix(train_data[, -which(names(train_data) == "medv")])
y_train <- train_data$medv

#Modelo Linear
regressao_linear = train(medv ~ ., data = train_data, method = "lm", trControl = trainControl(method = "cv", number = 5))
regressao_linear

#Arvore de decisao
set.seed(42)
tree_model <- train(medv ~ ., data = train_data, method = "rpart", trControl = trainControl(method = "cv", number = 10), tuneLength = 5)
tree_model
rpart.plot(tree_model$finalModel, main = "Árvore de Regressão")

#lasso
set.seed(42)
modelo_lasso = train(x = x_train, y = y_train, method = "glmnet", tuneGrid = expand.grid(alpha = 1, lambda = seq(0.001, 1, length = 20)), trControl = trainControl(method = "cv", number = 10))
modelo_lasso

#Random Forest
set.seed(42)
modelo_rf = train(medv ~ ., data = train_data, method = "rf", trControl = trainControl(method = "cv", number = 5), tuneLength = 5)
modelo_rf