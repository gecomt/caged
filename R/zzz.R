#' Função a ser chamada ao carregar o pacote
#'
#' @param libname Nome da biblioteca.
#' @param pkgname Nome do pacote.
.onLoad <- function(libname, pkgname) {
  # Exibe uma mensagem de boas-vindas ao carregar o pacote
  packageStartupMessage("Bem-vindo ao pacote! Verificando a disponibilidade dos microdados")

  # Executa a função check_ftp_status ao carregar o pacote
  check_ftp_status()
}
