# Create SGS code

SGS code is an objects that represents the SGS code used to download
datasets from the SGS API.

## Usage

``` r
sgs(..., load_info = FALSE)
```

## Arguments

- ...:

  numeric codes (preferably named)

- load_info:

  \`logical\` indicating with the dataset info shoud be loaded (default
  FALSE). The info is scraped from the SGS website, which is often
  unavailable.

## Value

an SGS object representing SGS codes

## Examples

``` r
if (FALSE) { # \dontrun{
sgs(USD = 1, IPCA = 433)
} # }
```
