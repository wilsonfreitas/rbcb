# Get market expectations

General function to get statistics of market expectations. The API
provides requests for annual, monthly, and quarterly expectations. Is is
also proveided expectations for 12 months ahead, specific requests for
the top 5 indicators for annual and monthly expectations and data
provided by financial institutions.

## Usage

``` r
get_market_expectations(
  type = c("annual", "quarterly", "monthly", "inflation-12-months", "top5s-monthly",
    "top5s-annual", "selic", "top5s-selic"),
  indic = NULL,
  start_date = NULL,
  end_date = NULL,
  keep_names = TRUE,
  ...
)
```

## Arguments

- type:

  a character with one of the following: `annual`, `quarterly`
  `monthly`, `inflation-12-months`, `top5s-monthly`, `top5s-annual`.

- indic:

  a character vector with economic indicators names. They are case
  sensitive and don't forget the accents.

- start_date:

  series initial date. Accepts ISO character formated date and `Date`.

- end_date:

  series final date. Accepts ISO character formated date and `Date`.

- keep_names:

  if `TRUE` keeps the column names returned by the API (in portuguese),
  if `FALSE` the columns are renamed to standardized names (in english).

- ...:

  additional parameters to be passed to the API

  `type` defines the API used to fetch data.

  - `selic`: refers to the API \*Expectativas de Mercado Selic -
    Estatísticas\* for SELIC rate expectations

  - `annual`: refers to the API \*Expectativas de Mercado Anuais\* for
    annual market expectations

  - `quarterly`: refers to the API \*Expectativas de Mercado
    Trimestrais\* for quarterly market expectations

  - `monthly`: refers to the API \*Expectativas de Mercado Mensais\* for
    monthly market expectations

  - `inflation-12-months`: refers to the API \*Expectativas de mercado
    para inflação nos próximos 12 meses\* for market expectations of
    inflation indexes for the next 12 months.

  - `top5s-selic`: refers to the API \*Expectativas de Mercado Selic
    Top5\* for SELIC rate expectations of top 5's

  - `top5s-monthly`: refers to the API \*Expectativas de mercado mensais
    para os indicadores do Top 5\* for monthly market expectations of
    top 5's

  - `top5s-annual`: refers to the API \*Expectativas de mercado anuais
    para os indicadores do Top 5\* for annual market expectations of top
    5's

  `indic` argument must be one of indicators listed in Details.
  Respecting the case, blank spaces and accents.

  The `...` is to be used with API's parameters. `$top` to specify the
  maximum number of rows to be returned, this returns the `$top` rows,
  in chronological order. `$skip` can be used to ignore the first rows.
  If provided `$filter` applies filters according to
  \<https://olinda.bcb.gov.br/olinda/servico/ajuda\>.

## Value

A `data.frame` with the requested data.

## Details

All statistics are computed based on expectations provided by many
financial institutions in Brazil: banks, funds, risk managers, so on and
so forth. These expections and its statistics are used to build the
FOCUS Report weekly released by the Brazilian Central Bank.

There are market expectations available for the following indicators:

- Balança Comercial

- Câmbio

- Conta corrente

- Dívida bruta do governo geral

- Dívida líquida do setor público

- IGP-DI

- IGP-M

- INPC

- Investimento direto no país

- IPA-DI

- IPA-M

- IPCA

- IPCA Administrados

- IPCA Alimentação no domicílio

- IPCA Bens industrializados

- IPCA Livres

- IPCA Serviços

- IPCA-15

- IPC-FIPE

- PIB Agropecuária

- PIB Despesa de consumo da administração pública

- PIB despesa de consumo das famílias

- PIB Exportação de bens e serviços

- PIB Formação Bruta de Capital Fixo

- PIB Importação de bens e serviços

- PIB Indústria

- PIB Serviços

- PIB Total

- Produção industrial

- Resultado nominal

- Resultado primário

- Selic

- Taxa de desocupação

Check
\<https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/documentacao\>
for more details

## Examples

``` r
if (FALSE) { # \dontrun{
indic <- c("IPCA", "Câmbio")
x <- get_market_expectations("annual", indic, `$top` = 10)

x <- get_market_expectations("monthly", "Selic", `$top` = 20)

# get monthly expectations for top 5 indicators since 2021
x <- get_market_expectations("top5s-monthly", start_date = "2021-01-01")

# get annual expectations for top 5 indicators since 2021
x <- get_market_expectations("top5s-annual", `$top` = 20)

# get all inflation expectations for 12 months ahead starting on 2021-01
x <- get_market_expectations("inflation-12-months", start_date = "2021-01-01")

# get all SELIC expectations informed by financial institutions since 2022
x <- get_market_expectations("selic", start_date = "2022-01-01")

# get TOP5 SELIC expectations starting on 2022
x <- get_market_expectations("top5s-selic", start_date = "2022-01-01")
} # }
```
