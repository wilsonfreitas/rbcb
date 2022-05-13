test_that("it should fetch data from annual market expectations API", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  indic <- "Balança comercial"
  start_date <- "2018-01-01"
  end_date <- "2018-01-31"
  x <- get_annual_market_expectations(indic, start_date, end_date)
  expect_s3_class(x, "data.frame")
  expect_equal(max(x$date), as.Date("2018-01-31"))
})