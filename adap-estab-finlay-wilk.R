################################################################################
########## Análise de Adaptabilidade e Estabilidade de Cultivares ##############

# Instalar pacotes
install.packages("readxl")
install.packages("dplyr")
install.packages("openxlsx")


# Carregar os pacotes necessários
library(readxl)
library(dplyr)
library(openxlsx)

# Carregar os dados da planilha
dados <- read_excel("2024.05.03 - IBI Soja.xlsx", sheet = "base_finlaywilk")
head(dados)

# Preparar os dados
dados <- dados %>%
  select(vistoria_id, macrorregiao, regiao_endafoclimatica, cultivar_aa, marca_aa, cultivar_faz, marca_faz, produ_aa, produ_faz, incremento, resultado) %>%
  rename(genotipo_aa = cultivar_aa, ambiente = regiao_endafoclimatica, rendimento_aa = produ_aa, genotipo_faz = cultivar_faz, rendimento_faz = produ_faz)
head(dados)

# Calcular o índice ambiental para cada ambiente
indices_ambientais_aa <- dados %>%
  group_by(ambiente) %>%
  summarise(indice_ambiental_aa = mean(rendimento_aa, na.rm = TRUE))

indices_ambientais_faz <- dados %>%
  group_by(ambiente) %>%
  summarise(indice_ambiental_faz = mean(rendimento_faz, na.rm = TRUE))

# Incorporar o índice ambiental aos dados
dados <- left_join(dados, indices_ambientais_aa, by = "ambiente")
dados <- left_join(dados, indices_ambientais_faz, by = "ambiente")

# Aplicar o método de Finlay e Wilkinson sem intercepto
resultados_aa <- dados %>%
  group_by(genotipo_aa, ambiente) %>%
  do({
    modelo_aa <- lm(log(rendimento_aa) ~ log(indice_ambiental_aa) - 1, data = .) # Regressão sem intercepto em escala logarítmica
    coef_angular_aa <- coef(modelo_aa)["log(indice_ambiental_aa)"] # Coeficiente angular
    data.frame(coef_angular_aa)
  }) %>%
  ungroup()

resultados_faz <- dados %>%
  group_by(genotipo_faz, ambiente) %>%
  do({
    modelo_faz <- lm(log(rendimento_faz) ~ log(indice_ambiental_faz) - 1, data = .) # Regressão sem intercepto em escala logarítmica
    coef_angular_faz <- coef(modelo_faz)["log(indice_ambiental_faz)"] # Coeficiente angular
    data.frame(coef_angular_faz)
  }) %>%
  ungroup()

# Transformar os coeficientes de regressão para a escala original
resultados_aa$coef_angular_aa <- exp(resultados_aa$coef_angular_aa)
resultados_faz$coef_angular_faz <- exp(resultados_faz$coef_angular_faz)

# Incorporar o coeficiente de regressão aos dados finais
dados_finais <- left_join(dados, resultados_aa, by = c("genotipo_aa", "ambiente"))
dados_finais <- left_join(dados_finais, resultados_faz, by = c("genotipo_faz", "ambiente"))

# Calcular a média do rendimento por genótipo e ambiente
medias_rendimento_aa <- dados %>%
  group_by(genotipo_aa, ambiente) %>%
  summarise(media_rendimento_aa = mean(rendimento_aa, na.rm = TRUE)) %>%
  ungroup()

medias_rendimento_faz <- dados %>%
  group_by(genotipo_faz, ambiente) %>%
  summarise(media_rendimento_faz = mean(rendimento_faz, na.rm = TRUE)) %>%
  ungroup()

# Incorporar a média do rendimento aos dados finais
dados_finais <- left_join(dados_finais, medias_rendimento_aa, by = c("genotipo_aa", "ambiente"))
dados_finais <- left_join(dados_finais, medias_rendimento_faz, by = c("genotipo_faz", "ambiente"))

# Exibir os dados finais com o coeficiente angular
print(dados_finais)

# Salvar os dados finais em um arquivo .xlsx
write.xlsx(dados_finais, "dados_finais.xlsx", rowNames = FALSE)
