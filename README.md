# rbcb

An interface to information provided by the [Brazilian Centra Bank](https://www.bcb.gov.br).
This package interfaces the [Brazilian Central Bank web services](https://www3.bcb.gov.br/sgspub) to provide data already formatted into R's data structures and download currency data 
from [Brazilian Centra Bank](https://www.bcb.gov.br) web site.

## Install

While it's not on CRAN, the way to get it installed is through `devtools`

```r
devtools::install_github('wilsonfreitas/rbcb')
```

## Usage

### Downloading time series from BCB web services

Download series calling `rbcb::get_series` passing the time series code is as the first argument.
For example, let's download the USDBRL time series which has `code = 1`.

```r
rbcb::get_series(1)
```

```
# A tibble: 8,024 × 2
                  data valor
*               <dttm> <dbl>
1  1984-11-28 12:00:00  2828
2  1984-11-29 12:00:00  2828
3  1984-11-30 12:00:00  2881
4  1984-12-03 12:00:00  2881
5  1984-12-04 12:00:00  2881
6  1984-12-05 12:00:00  2923
7  1984-12-06 12:00:00  2923
8  1984-12-07 12:00:00  2923
9  1984-12-10 12:00:00  2965
10 1984-12-11 12:00:00  2965
# ... with 8,014 more rows
```

Note that this series starts at 1984 and has approximately 8000 rows.
To download recent values you should use the argument `last = N`, see below.

```r
rbcb::get_series(1, last = 10)
```

```
# A tibble: 10 × 2
                  data  valor
*               <dttm>  <dbl>
1  2016-11-28 12:00:00 3.3996
2  2016-11-29 12:00:00 3.4060
3  2016-11-30 12:00:00 3.3967
4  2016-12-01 12:00:00 3.4362
5  2016-12-02 12:00:00 3.4650
6  2016-12-05 12:00:00 3.4598
7  2016-12-06 12:00:00 3.4354
8  2016-12-07 12:00:00 3.3895
9  2016-12-08 12:00:00 3.4008
10 2016-12-09 12:00:00 3.3858
```

The series can be downloaded as `tibble`, `xts` or `data.frame`, but the default is `tibble`.
See the next example where the Brazilian Broad Consumer Price Index (IPCA) is downloaded as `xts` object.

```r
rbcb::get_series(433, last = 12, as = 'xts')
```

```
                     433
2015-12-01 12:00:00 0.96
2016-01-01 12:00:00 1.27
2016-02-01 12:00:00 0.90
2016-03-01 12:00:00 0.43
2016-04-01 12:00:00 0.61
2016-05-01 12:00:00 0.78
2016-06-01 12:00:00 0.35
2016-07-01 12:00:00 0.52
2016-08-01 12:00:00 0.44
2016-09-01 12:00:00 0.08
2016-10-01 12:00:00 0.26
2016-11-01 12:00:00 0.18
```

### Downloading currency data

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
