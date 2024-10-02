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

#' Baixar Arquivos Antigos do CAGED
#'
#' Baixa os arquivos antigos do CAGED (Cadastro Geral de Empregados e Desempregados) para o intervalo de datas especificado e os salva em um diretório local.
#' @encoding UTF-8
#' @param inicio Uma string representando a data de início no formato "AAAA-MM". O padrão é `"2020-01"`.
#' @param fim Uma string representando a data de fim no formato "AAAA-MM". O padrão é `"2024-06"`.
#' @param diretorio Uma string especificando o diretório onde os arquivos de dados serão salvos. O padrão é `"dados_caged"`.
#'
#' @details
#' A função cria uma sequência de datas mensais entre `inicio` e `fim`, constrói as URLs correspondentes para cada arquivo de dados mensal e os baixa no diretório especificado. Se o diretório não existir, ele será criado.
#'
#' @return
#' Esta função não retorna um valor. Ela realiza suas operações pelos efeitos colaterais (baixando arquivos para o sistema de arquivos local).
#'
#' @examples
#' \dontrun{
#' # Baixar dados do CAGED de janeiro de 2020 a junho de 2024
#' download_old_caged(inicio = "2020-01", fim = "2024-06", diretorio = "dados_caged")
#' }
#'
#' @export

download_old_caged <- function(inicio = "2020-01", fim = "2024-06", diretorio = "dados_old_caged") {
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
    url <- sprintf("ftp://ftp.mtps.gov.br/pdet/microdados/CAGED/%s/CAGEDEST_%s%s.7z", ano, mes, ano)
    arquivo <- sprintf("%s/CAGEDEST_%s%s.7z", diretorio, mes, ano)

    # Baixar o arquivo
    download.file(url, arquivo, mode = "wb")
    cat("Arquivo baixado:", arquivo, "\n")
  }
}

#' Lê e combina arquivos CAGED compactados em um único data.frame
#'
#' Esta função busca todos os arquivos com extensão `.7z` em um diretório especificado, lê cada um usando `readr::read_csv2()`, converte os tipos de dados com `readr::type_convert()` e combina todos os data.frames resultantes em um único data.frame.
#' @encoding UTF-8
#' @param diretorio Caminho para o diretório que contém os arquivos `.7z` do CAGED. O padrão é `"dados_caged"`.
#' @return Um `data.frame` contendo os dados combinados de todos os arquivos `.7z` encontrados no diretório.
#' @details
#' Os arquivos `.7z` devem conter dados em formato CSV compatível com a função `readr::read_csv2()`. Certifique-se de que todos os arquivos no diretório tenham a mesma estrutura de dados para evitar erros na combinação.
#' @examples
#' \dontrun{
#' # Lê os arquivos do diretório padrão "dados_caged"
#' dados_caged <- read_caged()
#'
#' # Lê os arquivos de um diretório específico
#' dados_caged <- read_caged(diretorio = "meu_diretorio_caged")
#' }
#' @importFrom readr read_csv2 type_convert
#' @importFrom dplyr bind_rows
#' @importFrom janitor clean_names
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
  caged <- dplyr::bind_rows(lista_caged) %>% janitor::clean_names()

  return(caged)
}

#' Lê e combina arquivos CAGED antigos em um único data frame
#'
#' Esta função busca todos os arquivos com extensão `.7z` em um diretório especificado, lê cada um usando a função `read_csv2` do pacote `readr` com a codificação `ISO-8859-2`, ajusta os tipos de colunas conforme necessário e combina todos os data frames resultantes em um único data frame.
#' @encoding UTF-8
#' @param diretorio Uma string que especifica o diretório contendo os arquivos `.7z` do CAGED a serem lidos. O padrão é `"dados_caged"`.
#'
#' @return Um data frame contendo os dados combinados de todos os arquivos `.7z` lidos.
#'
#' @details
#' A função utiliza `list.files` para listar todos os arquivos com extensão `.7z` no diretório especificado. Para cada arquivo, lê o conteúdo usando `read_csv2` com a codificação `ISO-8859-2`. As colunas são automaticamente convertidas para os tipos apropriados usando `type_convert`. Se houver alguma coluna específica que apresente problemas de leitura, você pode ajustar o parâmetro `col_types` dentro da função `read_csv2`, substituindo `"problematic_column"` pelo nome da coluna problemática e definindo seu tipo apropriado (por exemplo, `col_character`).
#'
#' @examples
#' \dontrun{
#' # Lê os arquivos .7z do diretório padrão "dados_caged"
#' caged_data <- read_old_caged()
#'
#' # Lê os arquivos .7z de um diretório específico
#' caged_data <- read_old_caged(diretorio = "meu_diretorio")
#' }
#'@importFrom janitor clean_names
#' @export

read_old_caged <- function(diretorio = "dados_caged") {
  # Listar todos os arquivos .7z no diretório especificado
  arquivos <- list.files(diretorio, pattern = "\\.7z$", full.names = TRUE)

  # Inicializar uma lista para armazenar os data.frames temporários
  lista_caged <- list()

  for (arquivo in arquivos) {
    # Definir a codificação como ISO-8859-2 usando o parâmetro locale
    locale <- readr::locale(encoding = "ISO-8859-2")

    # Ler o arquivo .7z diretamente usando read_csv2 e especificar os tipos de coluna
    df <- readr::read_csv2(
      arquivo,
      locale = locale,
      col_types = readr::cols(
        .default = readr::col_guess(),  # Deixe o R tentar adivinhar para a maioria das colunas
        problematic_column = readr::col_character()  # Substitua por coluna problemática real
      )
    ) %>% readr::type_convert()

    lista_caged[[length(lista_caged) + 1]] <- df
  }

  # Combinar todos os data.frames em um único
  caged <- dplyr::bind_rows(lista_caged) %>% janitor::clean_names()

  return(caged)
}


#' Verifica arquivos no FTP do CAGED para um ano específico
#' Esta função verifica e retorna os arquivos disponíveis para um ano específico no FTP do CAGED.
#' O usuário precisa informar o ano no formato "YYYY" (exemplo: "2024").
#' @param ano Ano no formato "YYYY" (exemplo: "2024").
#' @return Uma lista com os arquivos encontrados no FTP para o ano especificado.
#' @export
show_files_ftp <- function(ano) {
  # Certifique-se de que o pacote RCurl está carregado
  if (!requireNamespace("RCurl", quietly = TRUE)) {
    stop("O pacote 'RCurl' é necessário, mas não está instalado. Por favor, instale-o.")
  }

  # Diretório base no FTP do CAGED
  diretorio_base <- "ftp://ftp.mtps.gov.br/pdet/microdados/NOVO%20CAGED"

  # Criar o caminho da pasta no FTP com base no ano informado
  pasta <- sprintf("%s/%s/", diretorio_base, ano)

  # Listar os arquivos no FTP usando RCurl
  lista_arquivos <- RCurl::getURL(pasta, ftp.use.epsv = FALSE, dirlistonly = TRUE)

  # Dividir a lista em arquivos individuais
  arquivos <- unlist(strsplit(lista_arquivos, "\n"))

  # Verificar se há arquivos na pasta
  if (length(arquivos) == 0) {
    stop("Nenhum arquivo encontrado na pasta ", pasta)
  }

  # Remover possíveis espaços em branco extras
  arquivos <- trimws(arquivos)

  # Retornar a lista de arquivos encontrados
  return(arquivos)
}

