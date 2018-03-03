# rbcb

[![Build Status](https://travis-ci.org/wilsonfreitas/rbcb.svg?branch=master)](https://travis-ci.org/wilsonfreitas/rbcb)
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

### Usage

#### The `get_series` function

<a name="single-series"></a>
Download the series by calling `rbcb::get_series` and pass the time series code is as the first argument.
For example, let's download the USDBRL time series which code is `1`.

```r
rbcb::get_series(c(USDBRL = 1))
```

```
# A tibble: 8,330 x 2
   date       USDBRL
 * <date>      <dbl>
 1 1984-11-28   2828
 2 1984-11-29   2828
 3 1984-11-30   2881
 4 1984-12-03   2881
 5 1984-12-04   2881
 6 1984-12-05   2923
 7 1984-12-06   2923
 8 1984-12-07   2923
 9 1984-12-10   2965
10 1984-12-11   2965
# ... with 8,320 more rows
```

Note that this series starts at 1984 and has approximately 8000 rows.
Also note that you can name the downloaded series by passing a named `vector` in the `code` argument.
To download recent values you should use the argument `last = N`, see below.

<a name="tibble-objects"></a>
```r
rbcb::get_series(c(USDBRL = 1), last = 10)
```

```
# A tibble: 10 x 2
   date       USDBRL
 * <date>      <dbl>
 1 2018-02-19   3.23
 2 2018-02-20   3.25
 3 2018-02-21   3.26
 4 2018-02-22   3.26
 5 2018-02-23   3.24
 6 2018-02-26   3.24
 7 2018-02-27   3.24
 8 2018-02-28   3.24
 9 2018-03-01   3.26
10 2018-03-02   3.26
```

<a name="download-types"></a>
The series can be downloaded in many different types: `tibble`, `xts`, `ts` or `data.frame`, but the default is `tibble`.
See the next example where the Brazilian Broad Consumer Price Index (IPCA) is downloaded as `xts` object.

<a name="xts-objects"></a>
```r
rbcb::get_series(c(IPCA = 433), last = 12, as = 'xts')
```

```
> rbcb::get_series(c(IPCA = 433), last = 12, as = 'xts')
            IPCA
2017-02-01  0.33
2017-03-01  0.25
2017-04-01  0.14
2017-05-01  0.31
2017-06-01 -0.23
2017-07-01  0.24
2017-08-01  0.19
2017-09-01  0.16
2017-10-01  0.42
2017-11-01  0.28
2017-12-01  0.44
2018-01-01  0.29
```

or as a `ts` object.

<a name="ts-objects"></a>
```r
rbcb::get_series(c(IPCA = 433), last = 12, as = 'ts')
```

```
       Jan   Feb   Mar   Apr   May   Jun   Jul   Aug   Sep   Oct   Nov   Dec
2017        0.33  0.25  0.14  0.31 -0.23  0.24  0.19  0.16  0.42  0.28  0.44
2018  0.29                                                                  
```

<a name="multiple-series"></a>
Multiple series can be downloaded at once by passing a named vector with the series codes.
The return is a named list with the downloaded series.

```r
rbcb::get_series(c(IPCA = 433, IGPM = 189), last = 12, as = 'ts')
```

```
$IPCA
       Jan   Feb   Mar   Apr   May   Jun   Jul   Aug   Sep   Oct   Nov   Dec
2017        0.33  0.25  0.14  0.31 -0.23  0.24  0.19  0.16  0.42  0.28  0.44
2018  0.29                                                                  

$IGPM
       Jan   Feb   Mar   Apr   May   Jun   Jul   Aug   Sep   Oct   Nov   Dec
2017              0.01 -1.10 -0.93 -0.67 -0.72  0.10  0.47  0.20  0.52  0.89
2018  0.76  0.07                                                            
```


#### Currency rates

<a name="currency-rates"></a>
Use currency functions to download currency rates from the BCB web site.

```r
get_currency("USD", "2017-03-01", "2017-03-10")
```

```
# A tibble: 8 × 3
        date    bid    ask
      <date>  <dbl>  <dbl>
1 2017-03-01 3.0970 3.0976
2 2017-03-02 3.1132 3.1138
3 2017-03-03 3.1358 3.1364
4 2017-03-06 3.1105 3.1111
5 2017-03-07 3.1179 3.1185
6 2017-03-08 3.1471 3.1477
7 2017-03-09 3.1729 3.1735
8 2017-03-10 3.1617 3.1623
```

The rates come quoted in BRL, so 3.0970 is worth 1 USD in BRL.
Trying another currency.

```r
get_currency("JPY", "2017-03-01", "2017-03-10")
```

```
# A tibble: 8 × 3
        date     bid     ask
      <date>   <dbl>   <dbl>
1 2017-03-01 0.02726 0.02727
2 2017-03-02 0.02721 0.02722
3 2017-03-03 0.02739 0.02740
4 2017-03-06 0.02734 0.02735
5 2017-03-07 0.02735 0.02736
6 2017-03-08 0.02744 0.02745
7 2017-03-09 0.02762 0.02764
8 2017-03-10 0.02750 0.02751
```

To see the avaliable currencies call `list_currencies`.

```r
list_currencies()
```

```
# A tibble: 216 × 5
                          name  code symbol          country_name country_code
*                        <chr> <dbl>  <chr>                 <chr>        <dbl>
1            AFEGANE AFEGANIST     5    AFN           AFEGANISTAO          132
2             RANDE/AFRICA SUL   785    ZAR         AFRICA DO SUL         7560
3              LEK ALBANIA REP   490    ALL ALBANIA, REPUBLICA DA          175
4                         EURO   978    EUR              ALEMANHA          230
5                KWANZA/ANGOLA   635    AOA                ANGOLA          400
6        DOLAR CARIBE ORIENTAL   215    XCD              ANGUILLA          418
7        DOLAR CARIBE ORIENTAL   215    XCD     ANTIGUA E BARBUDA          434
8  GUILDER ANTILHAS HOLANDESAS   325    ANG   ANTILHAS HOLANDESAS          477
9            RIAL/ARAB SAUDITA   820    SAR        ARABIA SAUDITA          531
10              DINAR ARGELINO    95    DZD               ARGELIA          590
# ... with 206 more rows
```

There are 216 currencies available.

#### Cross currency rates

<a name="cross-currency-rates"></a>
The API provides a matrix with the relations between exchange rates, this is the
matrix of cross currency rates.
This is a square matrix with the all exchange rates between all currencies.

```
x <- get_currency_cross_rates("2017-03-10")
dim(x)
```

```
[1] 156 156
```

Since there are many currencies it is interesting to subset the matrix.

```
cr <- c("USD", "BRL", "EUR", "CAD")
x[cr, cr]
```

```
          USD    BRL       EUR       CAD
USD 1.0000000 3.1623 0.9380896 1.3465764
BRL 0.3162255 1.0000 0.2966479 0.4258218
EUR 1.0659963 3.3710 1.0000000 1.4354454
CAD 0.7426240 2.3484 0.6966479 1.0000000
```

The rates are quoted by its columns labels, so the numbers in the BRL column are worth one currency unit in BRL.
