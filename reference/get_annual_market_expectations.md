# Get annual market expectations of economic indicators

Statistics for the annual expectations of economic indicators. All
statistics are computed based on annual expectations provided by many
financial institutions in Brazil: banks, funds, risk managers, so on and
so forth. These expections and its statistics are used to build the
FOCUS Report weekly released by the Brazilian Central Bank.

## Usage

``` r
get_annual_market_expectations(
  indic = NULL,
  start_date = NULL,
  end_date = NULL,
  ...
)
```

## Arguments

- indic:

  a character vector with economic indicators names. They are case
  sensitive and don't forget the accents.

- start_date:

  series initial date. Accepts ISO character formated date and `Date`.

- end_date:

  series final date. Accepts ISO character formated date and `Date`.

- ...:

  additional parameters to be passed to the API

  `indic` argument must be one of indicators listed in Details.
  Respecting the case, blank spaces and accents.

  The `...` is to be used with API's parameters. `$top` to specify the
  maximum number of rows to be returned, this returns the `$top` rows,
  in chronological order. There is also `$skip` to ignore the first
  rows.

## Value

A `data.frame` with the requested data.

## Details

There are annual expectations available for the following indicators:

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
\<https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/documentacao#ExpectativasMercadoAnuais\>
for more details

## Examples

``` r
if (FALSE) { # \dontrun{
indic <- c("PIB Total", "Fiscal")
end_date <- "2018-01-31"
x <- get_annual_market_expectations(indic, end_date = end_date, `$top` = 10)

# return all indicators for the specified date range
start_date <- "2021-01-01"
x <- get_annual_market_expectations(start_date = start_date, `$top` = 20)
} # }
```
