
context("monthly market expectations API")

test_that("it should fetch data from monthly market expectations API", {
  indic <- "IPCA"
  start_date <- "2018-01-01"
  end_date <- "2018-01-31"
  x <- get_monthly_market_expectations(indic, start_date, end_date)
  expect_is(x, "data.frame")
  expect_equal(max(x$date), as.Date("2018-01-31"))
})

test_that("it should fetch data from monthly market expectations API without start_date", {
  indic <- "IPCA"
  end_date <- "2018-01-31"
  x <- get_monthly_market_expectations(indic, end_date = end_date, `$top` = 10)
  expect_is(x, "data.frame")
})

test_that("it should fetch data from monthly market expectations API without end_date", {
  indic <- "IPCA"
  start_date <- "2018-01-02"
  x <- get_monthly_market_expectations(indic, start_date = start_date)
  expect_is(x, "data.frame")
  expect_equal(min(x$date), as.Date("2018-01-02"))
})
