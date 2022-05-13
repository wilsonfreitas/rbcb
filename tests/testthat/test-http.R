test_that("it should test http download", {
  url <- "https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/Moedas"
  f <- http_download("get", url)
  expect_message(http_download("get", url))
  expect_true(file.exists(f))
  options(rbcb_cache = FALSE)
  expect_silent(http_download("get", url))
  options(rbcb_cache = TRUE)
})
