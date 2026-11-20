# Convert tidy dataframe into a list

Convert a tidy dataframe into a list of separate time series objects
like \`xts\` and \`ts\` or even a \`tibble\` with a time series
representation ( two columns with dates and values).

## Usage

``` r
sgs_untidy(x, tidydf, as = c("tibble", "xts", "ts"))
```

## Arguments

- x:

  sgs object with the corresponding codes

- tidydf:

  tidy dataframe returned by \`rbcb_get\`

- as:

  the returning type (\`tibble\`, \`xts\`, \`ts\`)

## Value

a list with time series objects

## Examples

``` r
if (FALSE) { # \dontrun{
x <- sgs(USD = 1, SELIC = 1178)
df <- rbcb_get(x, from = Sys.Date() - 10)
sgs_untidy(x, df, as = "xts")
} # }
```
