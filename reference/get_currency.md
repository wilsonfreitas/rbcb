# Get currency values for a given period

Given a currency symbol and a time interval (in dates) this function
returns the bid and ask time series of currency rates.

## Usage

``` r
get_currency(
  symbol,
  start_date,
  end_date,
  as = c("tibble", "xts", "data.frame", "text")
)
```

## Arguments

- symbol:

  currency symbol

- start_date:

  time interval initial date

- end_date:

  time interval last date

- as:

  the object's returning type

  The `symbol` argument is a three digits character which represents one
  currency. The symbols can be obtained with `list_currencies`.

  The time series date range is defined by `start_date` and `end_date`.

## Value

The time series with the bid and ask currency rates regarding the given
symbol quoted in BRL. The default returning is a `tibble`-fashioned
`data.frame` with the three columns: `date`, `ask` and `bid`. The `as`
argument also accepts `data.frame` to return old fashioned data frames,
`xts` to return a xts object with two variables (bid and ask) and `text`
which returns the text content download from BCB site.

## Examples

``` r
if (FALSE) { # \dontrun{
get_currency("USD", "2017-03-01", "2017-03-10")
} # }
```
