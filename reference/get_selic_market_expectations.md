# Get Selic market expectations

Statistics of Selic market expectations. All statistics are computed
based on expectations provided by many financial institutions in Brazil:
banks, funds, risk managers, so on and so forth. These expections and
its statistics are used to build the FOCUS Report weekly released by the
Brazilian Central Bank.

## Usage

``` r
get_selic_market_expectations(start_date = NULL, end_date = NULL, ...)
```

## Arguments

- start_date:

  series initial date. Accepts ISO character formated date and `Date`.

- end_date:

  series final date. Accepts ISO character formated date and `Date`.

- ...:

  additional parameters to be passed to the API

  The `...` is to be used with API's parameters. `$top` to specify the
  maximum number of rows to be returned, this returns the `$top` rows,
  in chronological order. There is also `$skip` to ignore the first
  rows.

## Value

A `data.frame` with the requested data.

## Details

Check
\<https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/documentacao#ExpectativasMercadoSelic\>
for more details

## Examples

``` r
if (FALSE) { # \dontrun{
# return all indicators for the specified date range
start_date <- "2022-01-01"
x <- get_selic_market_expectations(start_date = start_date, `$top` = 20)
} # }
```
