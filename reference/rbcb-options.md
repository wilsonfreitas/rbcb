# rbcb options

Options used in rbcb inside some of its functions.

## Details

\* \`rbcb_cache\`: all downloaded data is stored in temporary
directories, if \`rbcb_cache\` is FALSE downloaded data overwrites files
if it already exists. Otherwise, download is not executed and the
existing file is returned. Defaults to TRUE. \* \`rbcb_verbose\`: if
TRUE verbose messages are displayed when http requests are executed with
httr. Defaults to FALSE.

## Examples

``` r
if (FALSE) { # \dontrun{
options(rbcb_cache = FALSE)
options(rbcb_verbose = TRUE)
} # }
```
