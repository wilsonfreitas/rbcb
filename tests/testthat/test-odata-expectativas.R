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

test_that("it should fetch data from monthly market expectations API", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  indic <- "IPCA"
  start_date <- "2018-01-01"
  end_date <- "2018-01-31"
  x <- get_monthly_market_expectations(indic, start_date, end_date)
  expect_s3_class(x, "data.frame")
  expect_equal(max(x$date), as.Date("2018-01-31"))
})

test_that("it should fetch data from monthly market expectations API without start_date", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  indic <- "IPCA"
  end_date <- "2018-01-31"
  x <- get_monthly_market_expectations(indic, end_date = end_date, `$top` = 10)
  expect_s3_class(x, "data.frame")
})

test_that("it should fetch data from monthly market expectations API without end_date", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  indic <- "IPCA"
  start_date <- "2018-01-02"
  x <- get_monthly_market_expectations(indic, start_date = start_date)
  expect_s3_class(x, "data.frame")
  expect_equal(min(x$date), as.Date("2018-01-02"))
})

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

test_that("it should fetch data from top 5s monthly market expectations API", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  indic <- "IGP-M"
  start_date <- "2018-01-01"
  end_date <- "2018-01-31"
  x <- get_top5s_monthly_market_expectations(indic, start_date, end_date)
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x)[2], 9)
  expect_equal(max(x$date), as.Date("2018-01-31"))

  # empty case
  indic <- "Selic"
  start_date <- "2022-01-01"
  end_date <- "2022-04-30"
  x <- get_top5s_monthly_market_expectations(indic, start_date, end_date)
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x)[2], 0)
})

test_that("it should fetch data from top 5s annual market expectations API", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  indic <- "IGP-M"
  start_date <- "2018-01-01"
  end_date <- "2018-01-31"
  x <- get_top5s_annual_market_expectations(indic, start_date, end_date)
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x)[2], 9)
  expect_equal(max(x$date), as.Date("2018-01-31"))
})

test_that("it should fetch data from selic market expectations API", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  start_date <- "2018-01-01"
  end_date <- "2018-01-31"
  x <- get_selic_market_expectations(start_date, end_date)
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x)[2], 10)
  expect_equal(max(x$date), as.Date("2018-01-31"))
})

test_that("it should fetch data from top 5s selic market expectations API", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  start_date <- "2018-01-01"
  end_date <- "2018-01-31"
  x <- get_top5s_selic_market_expectations(start_date, end_date)
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x)[2], 10)
  expect_equal(max(x$date), as.Date("2018-01-31"))
})
