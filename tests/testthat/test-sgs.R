if (!covr::in_covr()) {
  skip_on_cran()
  skip_if_offline()
}

test_that("it should create a sgs object", {
  code <- sgs(USD = 1)
  expect_s3_class(code, "sgs")
  expect_equal(code[["USD"]]$code, 1)
})

test_that("it should create a sgs object with unamed codes", {
  code <- sgs(1)
  expect_s3_class(code, "sgs")
  expect_equal(code[["1"]]$code, 1)
})

test_that("it should create a multiple sgs object", {
  code <- sgs(USD = 1, IPCA = 433)
  expect_s3_class(code, "sgs")
  expect_equal(length(code), 2)
  expect_equal(code[["USD"]]$code, 1)
  expect_equal(code[["IPCA"]]$code, 433)
})

test_that("it should fail to create a sgs object", {
  expect_error(sgs(0))
  expect_error(sgs(-1))
})

test_that("it should untidy dataframe", {
  x <- sgs(USD = 1, SELIC = 1178)
  df <- rbcb_get(x, from = Sys.Date() - 10)
  untidy_data <- sgs_untidy(x, df, as = "xts")
  expect_equal(length(untidy_data), length(x))
  expect_equal(sort(names(x)), sort(names(untidy_data)))
})