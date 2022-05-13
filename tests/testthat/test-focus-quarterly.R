test_that("it should fetch data from quarterly market expectations API", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  indic <- "PIB Total"
  start_date <- "2018-01-01"
  end_date <- "2018-01-31"
  x <- get_quarterly_market_expectations(indic, start_date, end_date)
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x)[2], 10)
  expect_equal(max(x$date), as.Date("2018-01-31"))
})