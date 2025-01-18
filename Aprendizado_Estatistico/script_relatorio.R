#Bibliotecas

install.packages("corrplot")
install.packages("caret")
install.packages("glmnet")
install.packages("rpart.plot")


library(MASS)#Boston
library(corrplot)
library(caret)
library(glmnet)
library(rpart.plot)


#Atribuido os dados
dados = Boston

#Explorar os dados

colSums(is.na(dados))
dim(dados)

#####EDA
summary(dados)
boxplot(dados$crim, main = "Boxplot de CRIM", horizontal = TRUE)

###Verifiando outliers na coluna crim
# Definir o número de desvios padrão
X = 3

# Calculando média e desvio padrão
media = mean(dados$crim, na.rm = TRUE)
desvio = sd(dados$crim, na.rm = TRUE)

# Calculando os limites inferior e superior
limite_inferior = media - X * desvio
limite_superior = media + X * desvio

# Identificando os outliers
outliers = dados$crim[dados$crim < limite_inferior | dados$crim > limite_superior]
print(outliers)
#REmovendo outliers de crim
dados = dados[dados$crim >= limite_inferior & dados$crim <= limite_superior, ]

# Conferir se os outliers foram removidos
boxplot(dados$crim, main = "Boxplot de CRIM sem Outliers", horizontal = TRUE)
dim(dados) #Verificando a nova dim dos dados


###Analise de medv - Variavel alvo

# Calcular média, mediana e desvio padrão
media_medv = mean(dados$medv, na.rm = TRUE)
print(paste("Média de MEDV:", round(media_medv, 2)))

mediana_medv = median(dados$medv, na.rm = TRUE)
print(paste("Mediana de MEDV:", round(mediana_medv, 2)))

desvio_padrao_medv = sd(dados$medv, na.rm = TRUE)
print(paste("Desvio Padrão de MEDV:", round(desvio_padrao_medv, 2)))

#Visualizando o compotamento da variavel
hist(dados$medv, main = "Distribuição de MEDV", xlab = "MEDV", col = "skyblue")
boxplot(dados$medv, main = "Boxplot de MEDV", col = "orange")

###Verifiando outliers na coluna medv

media = mean(dados$medv, na.rm = TRUE)
desvio = sd(dados$medv, na.rm = TRUE)

# Calcular os limites inferior e superior #VAlor de X ja foi configurado ao tratar de "crim"
limite_inferior = media - X * desvio
limite_superior = media + X * desvio

# Identificar os outliers
outliers = dados$medv[dados$medv < limite_inferior | dados$medv > limite_superior]
print(outliers)

###Matriz de correlcao
correlacao = cor(dados)
corrplot::corrplot(correlacao, method = "circle", tl.cex = 0.7)


#Dividindp do os dados
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
  predictions = predict(modelo, newdata = test_data)
  mse = mean((predictions - test_data$medv)^2)
  correlation = cor(predictions, test_data$medv)
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

#GRafico do mSE comparando modelo a modelo
ggplot(df_resultados, aes(x = modelo, y = MSE, fill = modelo)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  theme_minimal() +
  labs(title = "MSE dos Modelos (- eh melhor)", x = "Modelo", y = "MSE")

#Fazendo o importance feature do modelo Random Forest
importancia_rf = varImp(modelo_rf, scale = FALSE)
print(importancia_rf)

# Plotando o importance do modelo rf
ggplot(importancia_rf, aes(x = reorder(rownames(importancia_rf), Overall), y = Overall)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  coord_flip() +
  scale_y_continuous(breaks = seq(0, 10500, by = 1500)) +  # Adiciona divisões no eixo X
  labs(title = "Importância das Variáveis no Modelo Random Forest", x = "Variáveis", y = "Importância")

#Trerindo modelo rf com feature importance
set.seed(42)
modelo_rf2 <- train(
  medv ~ rm + lstat + dis + crim + indus + nox, 
  data = train_data, method = "rf", 
  trControl = trainControl(method = "cv", number = 5), 
  tuneLength = 5
)
print(modelo_rf2)

# Avaliação do modelo reduzido
resultados_rf2 = avaliacao(modelo_rf2, test_data)
resultados_rf2

# Comparação do modelo reduzido com os demais
df_resultados = rbind(df_resultados, data.frame(
  MSE = resultados_rf2$MSE,
  Correlation = resultados_rf2$Correlation,
  modelo = "Random (Reduzido)"
))

#GRafico agr com o mse do modelo reduzido
ggplot(df_resultados, aes(x = reorder(modelo, MSE), y = MSE, fill = modelo)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  theme_minimal() +
  labs(title = "Comparação de MSE dos Modelos", x = "Modelo", y = "MSE")

#FAzer uma matriz de correlacao com as variaveis escolhidas
# Selecionar as colunas desejadas
colunas_usadas = dados[, c("rm", "lstat", "dis", "crim", "indus", "nox", "medv")]
correlacao = cor(colunas_usadas, use = "complete.obs")
corrplot::corrplot(correlacao, method = "circle", tl.cex = 0.7)
