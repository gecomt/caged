
<!-- README.md is generated from README.Rmd. Please edit that file -->

# caged

<!-- badges: start -->
<!-- badges: end -->

O pacote foi desenvolvido para facilitar o download, leitura e
manipulação dos dados de movimentação do Cadastro Geral de Empregados e
Desempregados (CAGED). Embora os dados brutos estam disponíveis através
do diretório ftp do Ministério do Trabalho, através do [PDET (PROGRAMA
DE DISSEMINAÇÃO DAS ESTATÍSTICAS DO
TRABALHO)](ftp://ftp.mtps.gov.br/pdet/microdados/NOVO%%20CAGED/), não
qualquer o API o que torna o acesso nada intuitivo e prático.

## Instalação

Você pode instalar a versão de desenvolvimento do caged a partir do
[GitHub](https://github.com/) da seguinte forma:

``` r
# install.packages("pak")
pak::pak("gecomt/caged")
```

## Exemplo

Para baixar os dados de movimentação do CAGED utiliza-se a função
`baixar_dados_caged` definindo o período desejado (parâmentros `início`
e `fim`) e nome do `diretorio` que será criado para armazenar os dados
do CAGED

``` r
library(caged)
baixar_dados_caged(inicio = "2020-01", fim = "2024-06", diretorio = "dados_caged")
```

Logo após, será feita a leitura e união de todos os arquivos de
movimentação do CAGED em um único data frame. É preciso definir o local
onde os arquivos foram armazenados `diretorio` e atribuir um nome de
objeto a função que no exemplo a seguir foi nomeado como `df`

``` r
df = ler_juntar_caged(diretorio = "dados_caged") 
```
