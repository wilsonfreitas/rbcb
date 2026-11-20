# Get currency matrix from BCB

The currency matrix has the currency cross rates for all currencies
present in the BCB system.

## Usage

``` r
get_currency_cross_rates(date, ref = c("ask", "bid"))
```

## Arguments

- date:

  reference date

- ref:

  reffers to `bid` or `ask` rates (default `ask`)

  `date` is the reference date by which the currency rates must be
  downloaded. `ref` defaults to `ask` and `bid` returns all currency
  cross rates calculated with bid rates.

## Value

A square `matrix` with `colnames` and `rownames` filled with currency
symbols The cells must be read as `ROW` in `COL`, for example, BRL (row)
in USD (column) means Brazilian Reals in American Dollars.

## Examples

``` r
if (FALSE) { # \dontrun{
x <- get_currency_cross_rates("2017-03-10")
currencies <- c("USD", "BRL", "AUD", "EUR", "CAD")
x[currencies, currencies]
} # }
```
