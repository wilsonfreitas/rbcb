test_that("it should get one series as data.frame", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  x <- get_series(1, last = 10)
  expect_equal(dim(x)[1], 10)
  expect_equal(dim(x)[2], 2)
  expect_true(!anyNA(x[, 1]))
  expect_true(!anyNA(x[, 2]))
  expect_s3_class(x, "data.frame")
  expect_s3_class(x$date, "Date")
  expect_type(x$`1`, "double")
})

test_that("it should name the series", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  x <- get_series(c(USD = 1), last = 10)
  expect_equal(colnames(x), c("date", "USD"))
})

test_that("it should get series as xts", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  x <- get_series(c(USD = 1), last = 10, as = "xts")
  expect_equal(colnames(x), "USD")
})

test_that("it should get series as ts", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  x <- get_series(13521, start_date = "2012-01-01", as = "ts")
  expect_equal(frequency(x), 1)
  expect_s3_class(x, "ts")
  expect_equal(start(x), c(2012, 1))

  x <- get_series(28563, start_date = "2012-04-01", as = "ts")
  expect_equal(frequency(x), 4)
  expect_s3_class(x, "ts")
  expect_equal(start(x), c(2012, 2))
  x <- get_series(28563, start_date = "2022-02-01", as = "ts")
  expect_equal(start(x), c(2022, 1))
  x <- get_series(28563, start_date = "2022-05-01", as = "ts")
  expect_equal(start(x), c(2022, 2))
  x <- get_series(28563, start_date = "2022-08-01", as = "ts")
  expect_equal(start(x), c(2022, 3))
  x <- get_series(28563, start_date = "2022-11-01", as = "ts")
  expect_equal(start(x), c(2022, 4))

  x <- get_series(c(IPCA = 433), start_date = "2017-01-01", as = "ts")
  expect_equal(frequency(x), 12)
  expect_s3_class(x, "ts")
  expect_equal(start(x), c(2017, 1))

  x <- get_series(1, last = 10, as = "ts")
  expect_equal(frequency(x), 366)
  expect_s3_class(x, "ts")
  expect_equal(length(x), 10)
})

test_that("it should get series as data.frame", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  x <- get_series(1, last = 10, as = "data.frame")
  expect_s3_class(x, "data.frame")
  expect_equal(nrow(x), 10)
})

test_that("it should get series within a date period", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  x <- get_series(c(USD = 1), start_date = "2017-03-01", end_date = "2017-03-29")
  expect_s3_class(x$date, "Date")
  expect_true(x$date[1] == "2017-03-01")
  expect_true(x$date[dim(x)[1]] == "2017-03-29")
})

test_that("it should get series within a date period specifying only start_date", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  start <- Sys.Date() - 10
  x <- get_series(c(USD = 1), start_date = start)
  expect_s3_class(x$date, "Date")
  expect_true(nrow(x) >= 6)
})

test_that("it should get series within a date period specifying only end_date", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  end <- "2017-01-02"
  x <- get_series(c(USD = 1), end_date = end)
  expect_s3_class(x$date, "Date")
  expect_true(x$date[nrow(x)] == end)
})

test_that("it should get multiple series", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  start <- Sys.Date() - 10
  x <- get_series(c(USD = 1, SELIC = 1178), start_date = start)
  expect_equal(length(x), 2)
  expect_equal(sort(names(x)), c("SELIC", "USD"))

  x <- get_series(c(USD = 1, 1178), last = 5)
  expect_equal(length(x), 2)
  expect_equal(sort(names(x)), c("1178", "USD"))
})