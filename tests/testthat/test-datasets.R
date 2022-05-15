if (!covr::in_covr()) {
  skip_on_cran()
  skip_if_offline()
}

test_that("it should search for datasets", {
  res <- search_datasets("")
  expect_equal(dim(res$results), c(10, 8))
  expect_true(res$count > 0)
})

test_that("it should get empty dataframe for offset search", {
  res <- search_datasets("IPCA", 100)
  expect_equal(dim(res$results), c(0, 0))
  expect_true(res$count > 0)
})

test_that("it should get dataset info", {
  id <- "cd40e9bf-bac4-4eaf-9d64-27e97e526e6c"
  res <- dataset_info(id)
  expect_equal(res$id, id)
  expect_type(res, "list")
})