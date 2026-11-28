test_that("it should get currency data from BCB", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  x <- get_currency("USD", "2017-03-01", "2017-03-02", as = "text")
  expect_type(x, "character")
  expect_equal(x, "01032017;220;A;USD;3,0970;3,0976;1,0000;1,0000\n02032017;220;A;USD;3,1132;3,1138;1,0000;1,0000\n")
})

test_that("it should get a time series of a currency from bcb", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  x <- get_currency("USD", "2017-03-01", "2017-03-14")
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), c(10, 3))
  expect_error(
    get_currency("BRL", "2017-03-01", "2017-03-14")
  )
})

test_that("it should get currency code", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  x <- get_currency_id("BRL")
  expect_equal(x, 177)
})

test_that("it should get MXN and ARS data", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  x <- get_currency("MXN", "2018-05-28", "2018-05-30")
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), c(3, 3))
  x <- get_currency("ARS", "2018-05-28", "2018-05-30")
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), c(3, 3))
})

test_that("it should get a time series with a symbol attribute", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  x <- get_currency("USD", "2017-03-01", "2017-03-14")
  expect_s3_class(x, "data.frame")
  expect_equal(attr(x, "symbol"), "USD")
  x <- get_currency("USD", "2017-03-01", "2017-03-14", as = "xts")
  expect_s3_class(x, "xts")
  expect_equal(attr(x, "symbol"), "USD")
})

test_that("it should get ask/bid time series named with symbol", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  x <- get_currency("USD", "2017-03-01", "2017-03-14")
  x_ask <- Ask(x)
  expect_equal(colnames(x_ask), c("date", "USD"))
  x_bid <- Bid(x)
  expect_equal(colnames(x_bid), c("date", "USD"))
  x <- get_currency("USD", "2017-03-01", "2017-03-14", as = "xts")
  x_ask <- Ask(x)
  expect_equal(colnames(x_ask), "USD")
  x_bid <- Bid(x)
  expect_equal(colnames(x_bid), "USD")
})

test_that("it should get cross currency rates", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  x <- get_currency_cross_rates("2017-03-10")
  d <- dim(x)
  expect_equal(d[1], d[2])
})

test_that("it should list currencies", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  x <- list_currencies()
  expect_s3_class(x, "data.frame")
})

test_that("get_valid_currency_list goes back only on 404, at most 10 days", {
  err <- function(status) {
    stop(structure(
      class = c("rbcb_http_error", "error", "condition"),
      list(message = paste("Request error", status), call = NULL, status = status)
    ))
  }
  calls <- 0
  local_mocked_bindings(http_getter = function(url) {
    calls <<- calls + 1
    if (grepl("M20261127", url)) "ok" else err(404)
  })
  expect_equal(get_valid_currency_list(as.Date("2026-11-29")), "ok")
  expect_equal(calls, 3)

  calls <- 0
  expect_error(get_valid_currency_list(as.Date("2026-01-31")), "last 10 days")
  expect_equal(calls, 10)

  calls <- 0
  local_mocked_bindings(http_getter = function(url) {
    calls <<- calls + 1
    err(503)
  })
  expect_error(get_valid_currency_list(), "503")
  expect_equal(calls, 1)
})

test_that("get_currency_id gives a clear error for an unknown symbol", {
  local_mocked_bindings(
    currency_id_list = function() data.frame(id = c(61, 222), name = c("x", "y")),
    get_currency_list = function() data.frame(name = c("x", "y"), symbol = c("USD", "EUR"))
  )
  expect_equal(get_currency_id("USD"), 61)
  expect_error(get_currency_id("XXX"), "Unknown currency symbol: XXX")
})
