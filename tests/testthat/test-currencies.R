
context("currencies")

test_that("it should get a time series of a currency from bcb", {
  x <- get_currency("USD", "2017-03-01", "2017-03-14")
  expect_is(x, "data.frame")
  expect_equal(dim(x), c(10, 3))
  expect_error(
    get_currency("BRL", "2017-03-01", "2017-03-14")
  )
})

test_that("it should get currency code", {
  x <- get_currency_id("BRL")
  expect_equal(x, 177)
})
