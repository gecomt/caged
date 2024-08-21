#' <descrição
#'
#' @encoding UTF-8
#' @description
#' Esta função verifica se um servidor FTP está online, dado um URL padrão.
#'
#' @param ftp_url Uma string contendo o URL do servidor FTP a ser verificado. O valor padrão é
#' "ftp://ftp.mtps.gov.br/pdet/microdados/".
#'
#' @return Nenhum valor é retornado. A função imprime uma mensagem indicando se o FTP está online ou offline.
#'
#' @examples
#' # Verifica o status do FTP padrão
#' check_ftp_status()
#'
#' # Verifica o status de um FTP personalizado
#' check_ftp_status("ftp://example.com")
#'
#' @import RCurl
#' @import progress
#' @export
check_ftp_status <- function(ftp_url = "ftp://ftp.mtps.gov.br/pdet/microdados/") {
  status <- tryCatch({
    url.exists(ftp_url)
  }, error = function(e) {
    FALSE
  })

  if (status) {
    print("O FTP MTE PDET online.")
  } else {
    print("O FTP MTE PDET offline.")
  }
}
