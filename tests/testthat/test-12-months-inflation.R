test_that("it should fetch data from 12-months-infl market expectations API", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  indic <- "IPCA"
  start_date <- "2018-06-22"
  end_date <- "2018-06-22"
  x <- get_twelve_months_inflation_expectations(indic, start_date, end_date)
  expect_s3_class(x, "data.frame")
  expect_equal(NROW(x), 4)
  expect_equal(max(x$date), as.Date("2018-06-22"))
})