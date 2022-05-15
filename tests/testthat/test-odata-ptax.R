test_that("it should test odata currency", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  x <- olinda_get_currency("USD", "2017-03-01", "2017-03-02")
  expect_s3_class(x, "data.frame")
  expect_equal(attr(x, "symbol"), "USD")

  bid <- Bid(x)
  ask <- Ask(x)
  expect_equal(names(bid), c("datetime", "USD"))
  expect_equal(names(ask), c("datetime", "USD"))

  x <- olinda_get_currency("USD", "2017-03-01", "2017-03-14", as = "xts")
  expect_s3_class(x, "xts")
  expect_equal(attr(x, "symbol"), "USD")

  x_ask <- Ask(x)
  x_bid <- Bid(x)
  expect_equal(colnames(x_ask), "USD")
  expect_equal(colnames(x_bid), "USD")
})

test_that("it should test odata currency for single date", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  x <- olinda_get_currency("USD", "2017-03-01")
  expect_s3_class(x, "data.frame")
  expect_equal(attr(x, "symbol"), "USD")
  expect_equal(as.Date(max(x$datetime)), as.Date("2017-03-01"))
})

test_that("it should test odata currency with parity", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  x <- olinda_get_currency("USD", "2017-03-01", parity = TRUE)
  expect_s3_class(x, "data.frame")
  expect_equal(attr(x, "symbol"), "USD")
  expect_equal(as.Date(max(x$datetime)), as.Date("2017-03-01"))
  expect_true(all(x$bid == 1))
  expect_equal(x$bid, x$ask)
})

test_that("it should test odata currency as text", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  x <- olinda_get_currency("USD", "2017-03-01", parity = TRUE, as = "text")
  expect_type(x, "character")
})

test_that("it should test odata list currencis", {
  if (!covr::in_covr()) {
    skip_on_cran()
    skip_if_offline()
  }

  x <- olinda_list_currencies()
  expect_s3_class(x, "data.frame")
  expect_equal(dim(x), c(10, 3))
})