
context("12 months inflation market expectations API")

test_that("it should fetch data from 12-months-infl market expectations API", {
  indic <- "IPCA"
  start_date <- "2018-06-22"
  end_date <- "2018-06-22"
  x <- get_twelve_months_inflation_expectations(indic, start_date, end_date)
  expect_is(x, "data.frame")
  expect_equal(NCOL(x), 9)
  expect_equal(NROW(x), 4)
  expect_equal(max(x$date), as.Date("2018-06-22"))
})
