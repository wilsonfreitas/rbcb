
context("annual market expectations API")

test_that("it should fetch data from annual market expectations API", {
  indic <- "Balança comercial"
  start_date <- "2018-01-01"
  end_date <- "2018-01-31"
  x <- get_annual_market_expectations(indic, start_date, end_date)
  expect_is(x, "data.frame")
  expect_equal(max(x$date), as.Date("2018-01-31"))
})
