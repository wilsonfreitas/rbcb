
context("series object")

test_that("it should create series objects", {
  code = c(IBOVESPA = 7)
  x = series_obj(code)[[1]]
  expect_is(x, "series_obj")
  expect_equal(x$code, 7)
  expect_equal(x$name, 'IBOVESPA')

  code = c(IBOVESPA = 7, 433)
  x = series_obj(code)
  expect_is(x, "list")
  expect_equal(x[[1]]$code, 7)
  expect_equal(x[[1]]$name, 'IBOVESPA')
  expect_equal(x[[2]]$code, 433)
  expect_equal(x[[2]]$name, '433')
})

test_that("it should create series url", {
  url = "https://www3.bcb.gov.br/sgspub/consultarvalores/consultarValoresSeries.do?method=consultarGraficoPorId&hdOidSeriesSelecionadas=7"
  code = c(IBOVESPA = 7)
  x = series_obj(code)[[1]]
  expect_equal(series_info_url(x), url)
})

test_that("it should create series info", {
  code = c(IBOVESPA = 7)
  x = series_obj(code)[[1]]
  info = series_info(x)
  expect_equal(info$url, series_info_url(x))
})
