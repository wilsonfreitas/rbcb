# Helpers to access time series columns

Extraxt bid and ask data from time series objects.

## Usage

``` r
Bid(x, ...)

# S3 method for class 'data.frame'
Bid(x, ...)

# S3 method for class 'xts'
Bid(x, ...)

# S3 method for class 'olinda_df'
Bid(x, ...)

Ask(x, ...)

# S3 method for class 'data.frame'
Ask(x, ...)

# S3 method for class 'xts'
Ask(x, ...)

# S3 method for class 'olinda_df'
Ask(x, ...)
```

## Arguments

- x:

  time series objects containing data to be extracted

- ...:

  additional arguments

## Value

tibble with time series

## Examples

``` r
if (FALSE) { # \dontrun{
x <- get_currency("EUR", "2018-06-22", "2018-06-28")
Bid(x)
Ask(x)
} # }
```
