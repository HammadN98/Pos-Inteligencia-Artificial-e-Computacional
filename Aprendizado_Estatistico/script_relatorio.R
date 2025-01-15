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


#Modelo Linear
set.seed(42)
regressao_linear = train(medv ~ ., data = train_data, method = "lm", trControl = trainControl(method = "cv", number = 5))
regressao_linear

#Arvore de decisao
set.seed(42)

modelo_arvore = train(medv ~ ., data = train_data, method = "rpart", trControl = trainControl(method = "cv", number = 5), tuneLength = 5)
modelo_arvore
rpart.plot(modelo_arvore$finalModel, main = "Árvore de Regressao")

#lasso
set.seed(42)

x_train = as.matrix(train_data[, -which(names(train_data) == "medv")])
y_train = train_data$medv

modelo_lasso = train(x = x_train, y = y_train, method = "glmnet", tuneGrid = expand.grid(alpha = 1, lambda = seq(0.001, 1, length = 20)), trControl = trainControl(method = "cv", number = 5))
modelo_lasso

#Random Forest
set.seed(42)
modelo_rf = train(medv ~ ., data = train_data, method = "rf", trControl = trainControl(method = "cv", number = 5), tuneLength = 5)
modelo_rf

#calculo do MSE e correlação
avaliacao = function(modelo, test_data) {
  predictions <- predict(modelo, newdata = test_data)
  mse <- mean((predictions - test_data$medv)^2)
  correlation <- cor(predictions, test_data$medv)
  return(list(MSE = mse, Correlation = correlation))
}

resultados = list(
  LM = avaliacao(regressao_linear, test_data),
  Arvore = avaliacao(modelo_arvore, test_data),
  Lasso = avaliacao(modelo_lasso, test_data),
  Random = avaliacao(modelo_rf, test_data)  
)
resultados

df_resultados = do.call(rbind, lapply(resultados, as.data.frame))
df_resultados$modelo = rownames(df_resultados)
rownames(df_resultados) = NULL

library(ggplot2)
ggplot(df_resultados, aes(x = modelo, y = MSE, fill = modelo)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  theme_minimal() +
  labs(title = "MSE dos Modelos (- eh melhor)", x = "Modelo", y = "MSE")