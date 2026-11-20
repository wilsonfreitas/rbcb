# Gets data from BCB open data services

Gets SGS, currency, market expectations and many other datasets from the
Brazilian Central Bank open data services.

## Usage

``` r
rbcb_get(x, ...)

# S3 method for class 'sgs'
rbcb_get(x, from = NULL, to = NULL, last = 0, ...)
```

## Arguments

- x:

  an object that represents the kind of data to be downloaded

- ...:

  others arguments

- from:

  series initial date. Accepts ISO character formated date and `Date`.

- to:

  series final date. Accepts ISO character formated date and `Date`.

- last:

  last items of the series

  To use the SGS API a \`sgs\` object should be passed.

## Value

a dataset with the corresponding data (usually a \`tibble\`)

## Examples

``` r
if (FALSE) { # \dontrun{
x <- sgs(USD = 1, SELIC = 1178)
rbcb_get(x, from = Sys.Date() - 10)
} # }
```
