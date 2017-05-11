context("get_series")

test_that("it should get series json", {
  x <- get_series(1, start_date = "2017-03-01", end_date = "2017-03-01", as = "text")
  expect_is(x, "character")
  expect_true(jsonlite::validate(x))
  expect_equal(x, '[{"data":"01/03/2017","valor":"3.0976"}]')
})

test_that("it should get one series as data.frame", {
  x <- get_series(1, last = 10)
  expect_equal(dim(x)[1], 10)
  expect_equal(dim(x)[2], 2)
  expect_true(!anyNA(x[,1]))
  expect_true(!anyNA(x[,2]))
  expect_is(x, "data.frame")
  expect_is(x$date, "Date")
  expect_is(x$`1`, "numeric")
})

test_that("it should name the series", {
  x <- get_series(1, last = 10, name = "USD")
  expect_equal(colnames(x), c("date", "USD"))
})

test_that("it should get series as xts", {
  x <- get_series(1, last = 10, name = "USD", as = "xts")
  expect_equal(colnames(x), "USD")
})

test_that("it should get series within a date period", {
  x <- get_series(1, start_date = "2017-03-01", end_date = "2017-03-29", name = "USD")
  expect_is(x$date, "Date")
  expect_true(x$date[1] == "2017-03-01")
  expect_true(x$date[dim(x)[1]] == "2017-03-29")
})

test_that("it should get series within a date period specifying only start_date", {
  start <- Sys.Date() - 10
  x <- get_series(1, start_date = start, name = "USD")
  expect_is(x$date, "Date")
  expect_true(nrow(x) >= 6)
})

test_that("it should get series within a date period specifying only end_date", {
  end <- "2017-01-02"
  x <- get_series(1, end_date = end, name = "USD")
  expect_is(x$date, "Date")
  expect_true(x$date[nrow(x)] == end)
})

