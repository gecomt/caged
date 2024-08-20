dataCAGED
================
20 agosto 2024

<!-- README.md is generated from README.Rmd. Please edit that file -->
<p align="center">
<img src="man/figures/logo.png" width="20%">
</p>
<!-- badges: start -->
<!-- badges: end -->

O pacote foi desenvolvido para simplificar o processo de download,
leitura e manipulação dos dados de movimentação do novo Cadastro Geral
de Empregados e Desempregados (CAGED). Embora os dados brutos estejam
disponíveis no diretório FTP do Ministério do Trabalho, por meio do
[PDET (PROGRAMA DE DISSEMINAÇÃO DAS ESTATÍSTICAS DO
TRABALHO)](ftp://ftp.mtps.gov.br/pdet/microdados/NOVO%%20CAGED/), a
ausência de uma API oficial torna o acesso a esses dados pouco intuitivo
e pouco prático.

Desde janeiro de 2020, o uso do Sistema do Cadastro Geral de Empregados
e Desempregados (Caged) foi substituído pelo Sistema de Escrituração
Digital das Obrigações Fiscais, Previdenciárias e Trabalhistas (eSocial)
para parte das empresas, conforme estabelecido pela Portaria SEPRT nº
1.127, de 14/10/2019. Permanece a obrigatoriedade de envio das
informações por meio do Caged apenas para órgãos públicos e organizações
internacionais que contratam celetistas.

O Novo Caged é a geração das estatísticas do emprego formal por meio de
informações captadas dos sistemas eSocial, Caged e Empregador Web.

## Instalação

Você pode instalar a versão de desenvolvimento do caged a partir do
[GitHub](https://github.com/) da seguinte forma:

``` r
# install.packages("devtools")
devtools::install_github("gecomt/datacaged")
```

## Exemplo

Para baixar os dados de movimentação do CAGED utiliza-se a função
`download_caged` definindo o período desejado (parâmentros `início` e
`fim`) e nome do `diretorio` que será criado para armazenar os dados do
CAGED

``` r
library(datacaged)
download_caged(inicio = "2020-01", fim = "2024-06", diretorio = "dados_caged")
```

Logo após, será feita a leitura e união de todos os arquivos de
movimentação do CAGED em um único data frame. É preciso definir o local
onde os arquivos foram armazenados `diretorio` e atribuir um nome de
objeto a função que no exemplo a seguir foi nomeado como `df`

``` r
df = read_caged(diretorio = "dados_caged") 
```
