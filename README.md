# rbcb

[![Travis-CI build status](https://travis-ci.org/wilsonfreitas/rbcb.svg?branch=master)](https://travis-ci.org/wilsonfreitas/rbcb)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/wilsonfreitas/rbcb?branch=master&svg=true)](https://ci.appveyor.com/project/wilsonfreitas/rbcb)
[![Downloads](http://cranlogs.r-pkg.org/badges/rbcb?color=brightgreen)]( https://cran.r-project.org/package=rbcb)

An interface to structure the information provided by the [Brazilian Centra Bank](https://www.bcb.gov.br).
This package interfaces the [Brazilian Central Bank web services](https://www3.bcb.gov.br/sgspub) to provide data already formatted into R's data structures and download currency data 
from [Brazilian Centra Bank](https://www.bcb.gov.br) web site.

## Install

You can download it from CRAN

```r
install.packages('rbcb')
```

or use devtools:

```r
devtools::install_github('wilsonfreitas/rbcb')
```

## Features

- [Download single series](#single-series)
- [Download multiple series](#multiple-series)
- [Different download types](#download-types)
- [Download `tibble` objects](#tibble-objects)
- [Download `xts` objects](#xts-objects)
- [Download `ts` objects](#ts-objects)
- [Download currency rates](#currency-rates)
- [Download cross currency rates](#cross-currency-rates)
- [Download market expectations](#market-expectations)

### Usage

#### The `get_series` function

<a name="single-series"></a>
Download the series by calling `rbcb::get_series` and pass the time series code is as the first argument.
For example, let's download the USDBRL time series which code is `1`.

``` r
rbcb::get_series(c(USDBRL = 1))
#> # A tibble: 8,412 x 2
#>    date       USDBRL
#>  * <date>      <dbl>
#>  1 1984-11-28   2828
#>  2 1984-11-29   2828
#>  3 1984-11-30   2881
#>  4 1984-12-03   2881
#>  5 1984-12-04   2881
#>  6 1984-12-05   2923
#>  7 1984-12-06   2923
#>  8 1984-12-07   2923
#>  9 1984-12-10   2965
#> 10 1984-12-11   2965
#> # ... with 8,402 more rows
```

Note that this series starts at 1984 and has approximately 8000 rows.
Also note that you can name the downloaded series by passing a named `vector` in the `code` argument.
To download recent values you should use the argument `last = N`, see below.

<a name="tibble-objects"></a>
``` r
rbcb::get_series(c(USDBRL = 1), last = 10)
#> # A tibble: 10 x 2
#>    date       USDBRL
#>  * <date>      <dbl>
#>  1 2018-06-18   3.75
#>  2 2018-06-19   3.76
#>  3 2018-06-20   3.73
#>  4 2018-06-21   3.79
#>  5 2018-06-22   3.77
#>  6 2018-06-25   3.78
#>  7 2018-06-26   3.77
#>  8 2018-06-27   3.84
#>  9 2018-06-28   3.85
#> 10 2018-06-29   3.86
```

<a name="download-types"></a>
The series can be downloaded in many different types: `tibble`, `xts`, `ts` or `data.frame`, but the default is `tibble`.
See the next example where the Brazilian Broad Consumer Price Index (IPCA) is downloaded as `xts` object.

<a name="xts-objects"></a>
``` r
rbcb::get_series(c(IPCA = 433), last = 12, as = "xts")
#>             IPCA
#> 2017-06-01 -0.23
#> 2017-07-01  0.24
#> 2017-08-01  0.19
#> 2017-09-01  0.16
#> 2017-10-01  0.42
#> 2017-11-01  0.28
#> 2017-12-01  0.44
#> 2018-01-01  0.29
#> 2018-02-01  0.32
#> 2018-03-01  0.09
#> 2018-04-01  0.22
#> 2018-05-01  0.40
```

or as a `ts` object.

<a name="ts-objects"></a>
``` r
rbcb::get_series(c(IPCA = 433), last = 12, as = "ts")
#>        Jan   Feb   Mar   Apr   May   Jun   Jul   Aug   Sep   Oct   Nov
#> 2017                               -0.23  0.24  0.19  0.16  0.42  0.28
#> 2018  0.29  0.32  0.09  0.22  0.40                                    
#>        Dec
#> 2017  0.44
#> 2018
```

<a name="multiple-series"></a>
Multiple series can be downloaded at once by passing a named vector with the series codes.
The return is a named list with the downloaded series.

``` r
rbcb::get_series(c(IPCA = 433, IGPM = 189), last = 12, as = "ts")
#> $IPCA
#>        Jan   Feb   Mar   Apr   May   Jun   Jul   Aug   Sep   Oct   Nov
#> 2017                               -0.23  0.24  0.19  0.16  0.42  0.28
#> 2018  0.29  0.32  0.09  0.22  0.40                                    
#>        Dec
#> 2017  0.44
#> 2018      
#> 
#> $IGPM
#>        Jan   Feb   Mar   Apr   May   Jun   Jul   Aug   Sep   Oct   Nov
#> 2017                               -0.67 -0.72  0.10  0.47  0.20  0.52
#> 2018  0.76  0.07  0.64  0.57  1.38                                    
#>        Dec
#> 2017  0.89
#> 2018
```

#### Currency rates

<a name="currency-rates"></a>
Use currency functions to download currency rates from the BCB web site.

``` r
rbcb::get_currency("USD", "2017-03-01", "2017-03-10")
#> # A tibble: 8 x 3
#>   date         bid   ask
#>   <date>     <dbl> <dbl>
#> 1 2017-03-01  3.10  3.10
#> 2 2017-03-02  3.11  3.11
#> 3 2017-03-03  3.14  3.14
#> 4 2017-03-06  3.11  3.11
#> 5 2017-03-07  3.12  3.12
#> 6 2017-03-08  3.15  3.15
#> 7 2017-03-09  3.17  3.17
#> 8 2017-03-10  3.16  3.16
```

The rates come quoted in BRL, so 3.0970 is worth 1 USD in BRL.
Trying another currency.

``` r
library(rbcb)
library(magrittr)
get_currency("JPY", "2017-03-01", "2017-03-10") %>% Ask()
#> # A tibble: 8 x 2
#>   date          ask
#>   <date>      <dbl>
#> 1 2017-03-01 0.0273
#> 2 2017-03-02 0.0272
#> 3 2017-03-03 0.0274
#> 4 2017-03-06 0.0274
#> 5 2017-03-07 0.0274
#> 6 2017-03-08 0.0274
#> 7 2017-03-09 0.0276
#> 8 2017-03-10 0.0275
```

To see the avaliable currencies call `list_currencies`.

``` r
rbcb::list_currencies()
#> # A tibble: 218 x 5
#>    name                   code symbol country_name          country_code
#>  * <chr>                 <dbl> <chr>  <chr>                        <dbl>
#>  1 AFEGANE AFEGANIST         5 AFN    AFEGANISTAO                    132
#>  2 RANDE/AFRICA SUL        785 ZAR    AFRICA DO SUL                 7560
#>  3 LEK ALBANIA REP         490 ALL    ALBANIA, REPUBLICA DA          175
#>  4 EURO                    978 EUR    ALEMANHA                       230
#>  5 KWANZA/ANGOLA           635 AOA    ANGOLA                         400
#>  6 DOLAR CARIBE ORIENTAL   215 XCD    ANGUILLA                       418
#>  7 DOLAR CARIBE ORIENTAL   215 XCD    ANTIGUA E BARBUDA              434
#>  8 RIAL/ARAB SAUDITA       820 SAR    ARABIA SAUDITA                 531
#>  9 DINAR ARGELINO           95 DZD    ARGELIA                        590
#> 10 PESO ARGENTINO          706 ARS    ARGENTINA                      639
#> # ... with 208 more rows
```

There are 216 currencies available.

#### Cross currency rates

<a name="cross-currency-rates"></a>
The API provides a matrix with the relations between exchange rates, this is the
matrix of cross currency rates.
This is a square matrix with the all exchange rates between all currencies.

``` r
x <- rbcb::get_currency_cross_rates("2017-03-10")
dim(x)
#> [1] 156 156

# Since there are many currencies it is interesting to subset the matrix.
cr <- c("USD", "BRL", "EUR", "CAD")
x[cr, cr]
#>           USD    BRL       EUR       CAD
#> USD 1.0000000 3.1623 0.9380896 1.3465764
#> BRL 0.3162255 1.0000 0.2966479 0.4258218
#> EUR 1.0659963 3.3710 1.0000000 1.4354454
#> CAD 0.7426240 2.3484 0.6966479 1.0000000
```

The rates are quoted by its columns labels, so the numbers in the BRL column are worth one currency unit in BRL.


#### Market expectations

<a name="market-expectations"></a>
There are six functions to get market expectations data.

- `get_monthly_market_expectations`
- `get_quarterly_market_expectations`
- `get_annual_market_expectations` 
- `get_top5s_monthly_market_expectations`
- `get_top5s_annual_market_expectations`
- `get_twelve_months_inflation_expectations`

``` r
rbcb::get_monthly_market_expectations("IPCA", end_date = "2018-01-31", `$top` = 5)
#> # A tibble: 5 x 9
#>   indic date       reference_month  mean median    sd coefvar   min   max
#> * <chr> <date>     <ord>           <dbl>  <dbl> <dbl>   <dbl> <dbl> <dbl>
#> 1 IPCA  2018-01-31 2019-01         0.48    0.5   0.07    14.6  0.33  0.65
#> 2 IPCA  2018-01-31 2019-02         0.46    0.46  0.07    15.2  0.26  0.68
#> 3 IPCA  2018-01-31 2018-09         0.290   0.28  0.06    20.7  0.14  0.45
#> 4 IPCA  2018-01-31 2019-04         0.38    0.4   0.08    21.0  0.16  0.61
#> 5 IPCA  2018-01-31 2018-08         0.19    0.2   0.08    42.1  0.05  0.47
```
