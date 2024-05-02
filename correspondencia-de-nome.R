# Código para cruzar nomes de clientes de duas bases diferentes e identificar correspondências inexatas

# Instalar pacotes necessários
install.packages("readxl")
install.packages("stringdist")
install.packages("magrittr")
install.packages("dplyr")
install.packages("tidyr")
install.packages("writexl")

# Carregar bibliotecas
library(readxl)
library(stringdist)
library(magrittr)
library(dplyr)
library(tidyr)
library(writexl)

# Criar função para remover acentos e converter palavras para maiúsculo
ajustar <- function(texto) {
  # Verificar se o texto é do tipo character
  if (!is.character(texto)) {
    stop("O argumento 'texto' não é um vetor de caracteres.")
  }
  
  # Criar sequências de caracteres para substituição de acentos
  old_chars <- c("á", "à", "â", "ã", "é", "è", "ê", "í", "ì", "ó", "ò", "ô", "õ", "ú", "ù", "û", "ç", "ñ",
                 "Á", "À", "Â", "Ã", "É", "È", "Ê", "Í", "Ì", "Ó", "Ò", "Ô", "Õ", "Ú", "Ù", "Û", "Ç", "Ñ")
  new_chars <- c("a", "a", "a", "a", "e", "e", "e", "i", "i", "o", "o", "o", "o", "u", "u", "u", "c", "n",
                 "A", "A", "A", "A", "E", "E", "E", "I", "I", "O", "O", "O", "O", "U", "U", "U", "C", "N")
  
  # Substituir acentos
  texto_sem_acentos <- chartr(paste(old_chars, collapse = ""), paste(new_chars, collapse = ""), texto)
  
  # Remover espaços extras
  texto_sem_espacos_extra <- gsub("\\s+", " ", texto_sem_acentos)
  
  # Converter para maiúsculas
  texto_maiusculo <- toupper(texto_sem_espacos_extra)
  
  return(texto_maiusculo)
}

# Carregar o arquivo Excel e remover acentos durante o carregamento
df_milho <- read_excel("Base Clientes Planejado Milho.xlsx", sheet = "milho 24 rascunho", skip = 1, col_names = c("ID FILIAL", "REGIONAL", "FILIAL", "CÓDIGO CTV", "CTV", "CLIENTE", "FORNECEDOR AA", "HÍBRIDO AA", "HÍBRIDO CONCORRENTE", "TIPO", "QTD SCS")) %>%
  mutate(CLIENTE = ajustar(CLIENTE))
df_AA <- read_excel("Base Clientes Empresa.xlsx", sheet = "Base Protheus", skip = 1, col_names = c("PKCliente", "Código Empresa", "Codigo Cliente", "Codigo Fazenda", "CPF CNPJ", "Cliente", "Fazenda", "Código IBGE", "Município", "UF", "Grupo Cliente", "Classe Cliente", "Tipo Cliente", "Tipo Grupo")) %>%
  distinct(Cliente) %>%
  mutate(Cliente = ajustar(Cliente))

# Criar função para calcular o coeficiente de similaridade de Jaccard com n-grams
jaccard_ngram_similarity <- function(x, y, n = 2) {
  x_ngrams <- sapply(seq_len(nchar(x) - n + 1), function(i) substr(x, i, i + n - 1))
  y_ngrams <- sapply(seq_len(nchar(y) - n + 1), function(i) substr(y, i, i + n - 1))
  intersection <- length(intersect(x_ngrams, y_ngrams))
  union <- length(union(x_ngrams, y_ngrams))
  similarity <- intersection / union
  return(similarity)
}

# Criar função para encontrar o melhor correspondente, seu código de cliente correspondente e a pontuação de similaridade
correspondencia <- function(nome) {
  # Define um limite para a diferença de comprimento
  limite_diferenca_comprimento <- 5
  
  # Calcula a diferença de comprimento entre o nome fornecido e os nomes completos na base de dados df_AA
  diferencas_comprimento <- abs(nchar(nome) - nchar(df_AA$Cliente))
  
  # Verifica se a diferença de comprimento excede o limite
  if (any(diferencas_comprimento > limite_diferenca_comprimento)) {
    # Se a diferença de comprimento exceder o limite, retorna NA
    return(NA)
  } else {
    # Calcula o coeficiente de similaridade de Jaccard com n-grams entre o nome fornecido e todos os nomes completos na base de dados df_AA
    similaridades <- sapply(df_AA$Cliente, function(x) jaccard_ngram_similarity(nome, x))
    
    # Encontra o índice da maior similaridade
    indice_maior_similaridade <- which.max(similaridades)
    
    # Obtém a maior similaridade
    maior_similaridade <- max(similaridades)
    
    # Verifica se a maior similaridade está dentro do limite
    if (maior_similaridade >= 0.5) {
      codigo_cliente <- df_AA$Codigo_Cliente[indice_maior_similaridade]
      return(list(Best_Match = df_AA$Cliente[indice_maior_similaridade], "Codigo Cliente" = codigo_cliente, Pontuacao_Similaridade = maior_similaridade))
    } else {
      # Se não encontrar um correspondente próximo o suficiente, retorna NA
      return(NA)
    }
  }
}

# Aplicar a função em todas as linhas de df_milho para encontrar os melhores correspondentes
df_milho <- df_milho %>%
  mutate(Match = sapply(CLIENTE, correspondencia)) %>%
  unnest(cols = Match)

# Exportar o DataFrame resultante para um arquivo Excel
write_xlsx(df_milho, "Base Clientes Planejado Milho Resultado.xlsx")
