
context("currencies")

test_that("it should get currency data from BCB", {
  x <- get_currency("USD", "2017-03-01", "2017-03-02", as = "text")
  expect_is(x, "character")
  expect_equal(x, "01032017;220;A;USD;3,0970;3,0976;1,0000;1,0000\n02032017;220;A;USD;3,1132;3,1138;1,0000;1,0000\n")
})

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

test_that("it should get MXN and ARS data", {
  x <- get_currency("MXN", "2018-05-28", "2018-05-30")
  expect_is(x, "data.frame")
  expect_equal(dim(x), c(3, 3))
  x <- get_currency("ARS", "2018-05-28", "2018-05-30")
  expect_is(x, "data.frame")
  expect_equal(dim(x), c(3, 3))
})