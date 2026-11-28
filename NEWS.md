# rbcb (development version)

* Fix `olinda_get_currency()`: the PTAX OData API now requires dates as MM-DD-YYYY (Issue #67)
* `sgs()` and `get_series(as = "ts")` no longer fail when the SGS website is down (Issue #66):
  - `sgs()` now defaults to `load_info = FALSE`; the metadata page returns HTTP 502.
  - `get_series(as = "ts")` infers the series frequency from the dates instead of the metadata.
  - `sgs()` rejects invalid codes (zero, negative, non-numeric) directly.
* Daily SGS series can be downloaded again without `start_date` (Issue #64). The API limits daily
  series to 10-year windows, so longer periods are downloaded in 10-year windows and combined.
* SGS series that return a period for each value (TR 226, TBF 253) keep the end of the period
  in a new `enddate` column, in `rbcb_get()` and in `get_series(as = "tibble")` /
  `"data.frame"`. Before, the end date was dropped. `as = "xts"` and `"ts"` raise an error
  when two periods share a start date (Issue #82).
* `get_series(as = "text")` returns the raw JSON again: one string for one series, or a named
  list for several series. Before, it returned `NULL`. Periods longer than 10 years are joined
  into one JSON array, as in python-bcb (Issue #72).
* SGS series are always returned oldest-first. With `last = N`, some series (e.g. Selic 1178)
  came newest-first, so `as = "ts"` had a wrong start and reversed values (Issue #73).
* The currency list lookup (used by `get_currency()` and `list_currencies()`) goes back at most
  10 days, and only when a day has no file (HTTP 404). Before, any error (for example no network)
  made it go back one day at a time with no limit, until R stopped with "infinite recursion"
  (Issue #74).
* `get_currency()` with an unknown symbol stops with "Unknown currency symbol". Before, it gave a
  confusing `-Inf` warning and built a URL with `-Inf` in it (Issue #76).
* Cached downloads expire after one day. Before, a session that stayed open overnight got the
  first day's data again for URLs that do not change, such as `get_series(code, last = N)`
  (Issue #75).
* `print()` of `sgs()` objects shows the series names and codes again. The print methods were not
  registered, so R printed the raw list (Issue #77).
* The RStudio addins `rbcb_search()` and `rbcb_dataset()` work again: dataset search uses the
  CKAN v3 API of dadosabertos.bcb.gov.br (Issue #68).

# rbcb 0.1.14

* Correct BUG Issue #61 - Error importing quarterly data as ts objects

# rbcb 0.1.13

# rbcb 0.1.12

# rbcb 0.1.11

* created documentation site with pkgdown
* `rbcb_get` implemented for SGS API, it is being used as the infrastruture for get_series (Issue #17)
* new function `sgs_untidy` to convert tidy dataframes returned by `rbcb_get` to xts and ts objects
* NAMESPACE organized (use more importFrom instead of import in NAMESPACE)
* upgraded tests to testthat 3
* more tests to improve coverage
* implemented a cache system (thru `options`) (Issue #54)
* new functions that access datasets API

# rbcb 0.1.10

* added new Selic endpoints for market expectations API:
  `get_selic_market_expectations` and `get_top5s_selic_market_expectations`.
* Added a `NEWS.md` file to track changes to the package.

# rbcb 0.1.9

* added `skip_on_cran` to more tests that need connectivity
* added a `load_info` argument to `series_obj` function to enable/disable
  series information loading

# rbcb 0.1.8

* added `skip_on_cran` to tests that need connectivity
* added `\dontrun` to examples that need connectivity

# rbcb 0.1.7

* new market expectations function: `get_market_expectations`
* new API for exchange rates using olinda API
* new addins: rbcb_search, rbcb_dataset

# rbcb 0.1.6

* solved bug when downloading market expectations (issue #28)
* added new columns to market expectations API calls (issue #26)

# rbcb 0.1.5

* implemented functions to get market expectations data: `get_twelve_months_inflation_expectations`,
  `get_top5s_annual_market_expectations`, `get_top5s_monthly_market_expectations`
* implemented helpers to extract data from bid and ask columns of currency time series (issue #21)

# rbcb 0.1.4

* implemented functions to get market expectations data: `get_monthly_market_expectations`,
  `get_quarterly_market_expectations`, `get_annual_market_expectations`
* implemented a workaround to solve the BUG of duplicated currencies in the PTAX form (issue #19)

# rbcb 0.1.3

* implemented new naming style for get_series (issue #9)
* implemented the fetch of multiple series in one get_series call (issue #11)
* removed get_series ts_options argument, now it uses series info to define frequency and start

# rbcb 0.1.2

* implemented new functions to organize http requests
  * added User-Agent header to http requests
* implemented ts return for get_series (issue #5)
* changed search URL (issue #7)

# rbcb 0.1.1

* set default values in get_series to make API arguments optional

# rbcb 0.1.0

* first functional release

