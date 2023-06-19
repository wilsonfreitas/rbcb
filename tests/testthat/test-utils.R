test_that("it should test http download without cache", {
  url <- "https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/Moedas"
  op <- options(rbcb_cache = FALSE)
  withr::defer(options(op))
  expect_silent(http_download("get", url))
})

test_that("it should test http download with cache", {
  url <- "https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/Moedas"
  op <- options(rbcb_cache = TRUE)
  withr::defer(options(op))
  f <- http_download("get", url)
  expect_message(http_download("get", url))
  expect_true(file.exists(f))
})
