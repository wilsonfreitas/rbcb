# rbcb

An interface with [Brazilian Central Bank web services](https://www3.bcb.gov.br/sgspub) to provide data already formatted into R's data structures.

## Install

While it's not on CRAN, the way to get it installed is through `devtools`

```r
devtools::install_github('rbcb', username='wilsonfreitas')
```

## Usage

Download series calling `rbcb::get_series` where the time series code is passed as the first argument.
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
