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

