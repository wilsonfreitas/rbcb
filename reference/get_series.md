# Get the series from BCB

Get the series from BCB

## Usage

``` r
get_series(
  code,
  start_date = NULL,
  end_date = NULL,
  last = 0,
  as = c("tibble", "xts", "ts", "data.frame", "text")
)
```

## Arguments

- code:

  series code

- start_date:

  series initial date. Accepts ISO character formated date and `Date`.

- end_date:

  series final date. Accepts ISO character formated date and `Date`.

- last:

  last items of the series

- as:

  the returning type: data objects (`tibble, xts, data.frame, ts`) or
  `text` for raw JSON

  `code` argument can be obtained in the SGS system site. In this site
  searches can be executed in order to find out the desired series and
  use the series code in the `code` argument.

  The arguments `start_date`, `end_date` and `last` are optional. If
  none of these arguments are set, then the entire time series is
  downloaded. Define `start_date` and `end_date` to download a period of
  data and to download the last `N` registers define the `last` argument
  to `N` a positive integer. Once `last` is provided it overrides the
  arguments `start_date` and `end_date`.

## Value

`tibble` is the default returning class, but the argument `as` can be
set to `xts`, `data.frame`, `ts`, or `text` to return these other types.
`text` returns the JSON data provided by the remote API.

Series that return a period for each value (e.g. TR 226, TBF 253) have
an extra `enddate` column in `tibble` and `data.frame` output. `xts` and
`ts` are indexed by the start date only, and raise an error when two
periods share a start date.

## Examples

``` r
# download the entire series
if (FALSE) { # \dontrun{
get_series(1)
} # }
# download a period of dates
if (FALSE) { # \dontrun{
get_series(1, start_date = "2016-12-01")
} # }
if (FALSE) { # \dontrun{
x <- get_series(1, start_date = "2016-12-01", end_date = "2016-12-31")
} # }
# downlaod the last register
if (FALSE) { # \dontrun{
x <- get_series(1, last = 1)
} # }
```
