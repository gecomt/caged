#' Baixa CAGED
#' <descrição
#'
#' @encoding UTF-8
#' @description
#' Esta função baixa arquivos do CAGED para um diretório especificado.
#' @param inicio Data de início no formato "yyyy-mm" (padrão "2020-01").
#' @param fim Data de fim no formato "yyyy-mm" (padrão "2024-06").
#' @param diretorio Diretório onde os arquivos serão salvos (padrão "dados_caged").
#' @import readr
#' @import dplyr
#' @import archive
#' @import utils
#' @export
download_caged <- function(inicio = "2020-01", fim = "2024-06", diretorio = "dados_caged") {
  # Verificar e criar o diretório de destino, se não existir
  if (!dir.exists(diretorio)) {
    dir.create(diretorio)
  }

  # Gerar as sequências de anos e meses
  data_inicio <- as.Date(paste0(inicio, "-01"))
  data_fim <- as.Date(paste0(fim, "-01"))
  datas <- seq(data_inicio, data_fim, by = "month")

  # Loop para baixar os arquivos de cada mês
  for (data in datas) {
    ano <- format(as.Date(data), "%Y")
    mes <- format(as.Date(data), "%m")

    # Construir a URL e o nome do arquivo
    url <- sprintf("ftp://ftp.mtps.gov.br/pdet/microdados/NOVO%%20CAGED/%s/%s%s/CAGEDMOV%s%s.7z", ano, ano, mes, ano, mes)
    arquivo <- sprintf("%s/CAGEDMOV%s%s.7z", diretorio, ano, mes)

    # Baixar o arquivo
    download.file(url, arquivo, mode = "wb")
    cat("Arquivo baixado:", arquivo, "\n")
  }
}

#' Junta CAGED
#'
#' Esta função lê e junta arquivos CAGED salvos em um diretório especificado.
#' @param diretorio Diretório onde os arquivos .7z estão salvos (padrão "dados_caged").
#' @return Um data frame com todos os dados combinados.
#' @import readr
#' @import dplyr
#' @import archive
#' @export
read_caged <- function(diretorio = "dados_caged") {
  # Listar todos os arquivos .7z no diretório especificado
  arquivos <- list.files(diretorio, pattern = "\\.7z$", full.names = TRUE)

  # Inicializar uma lista para armazenar os data.frames temporários
  lista_caged <- list()

  for (arquivo in arquivos) {
    # Ler o arquivo .7z diretamente usando read_csv2
    df <- readr::read_csv2(arquivo) %>% readr::type_convert()
    lista_caged[[length(lista_caged) + 1]] <- df
  }

  # Combinar todos os data.frames em um único
  caged <- dplyr::bind_rows(lista_caged)

  return(caged)
}
