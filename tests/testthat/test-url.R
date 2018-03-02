
context('create URL')

ser = series_obj(c(USDBRL = 1))[[1]]

test_that('should create urls', {
  expect_equal(series_url(ser), 'http://api.bcb.gov.br/dados/serie/bcdata.sgs.1/dados?formato=json')
  end_date <- format(Sys.Date(), "%d%%2F%m%%2F%Y")

  url <- paste0('http://api.bcb.gov.br/dados/serie/bcdata.sgs.1/dados?formato=json&dataInicial=01%2F01%2F2016&dataFinal=', end_date)
  expect_equal(series_url(ser, start_date='2016-01-01'), url)

  url <- paste0('http://api.bcb.gov.br/dados/serie/bcdata.sgs.1/dados?formato=json&dataInicial=01%2F01%2F1900&dataFinal=01%2F01%2F2016')
  expect_equal(series_url(ser, end_date='2016-01-01'), url)

  expect_equal(series_url(ser, start_date='2016-01-01', end_date='2016-12-31'),
               'http://api.bcb.gov.br/dados/serie/bcdata.sgs.1/dados?formato=json&dataInicial=01%2F01%2F2016&dataFinal=31%2F12%2F2016')
  expect_equal(series_url(ser, last = 1),
               'http://api.bcb.gov.br/dados/serie/bcdata.sgs.1/dados/ultimos/1?formato=json')
  # once last is provided, dates are ignored
  suppressWarnings(
    expect_equal(series_url(ser, start_date='2016-01-01', end_date='2016-12-31', last = 1),
                 'http://api.bcb.gov.br/dados/serie/bcdata.sgs.1/dados/ultimos/1?formato=json')
  )
})

test_that('should warn for nonsense parameters', {
  expect_warning(series_url(ser, start_date = '2016-01-01', last = 1))
})

test_that('should create search url', {
  expect_equal(search_series_url('1'), 'https://dadosabertos.bcb.gov.br/dataset?res_format=JSON&q=1&page=1')
})

# test_that("it should create url using a code character", {
#   expect_equal(series_url('1'), c('1' = 'http://api.bcb.gov.br/dados/serie/bcdata.sgs.1/dados?formato=json'))
# })

# test_that("it should create multiple urls", {
#   urls = series_url(c(1, 7))
#   expect_equal(length(urls), 2)
#   expect_equal(urls, c('1' = 'http://api.bcb.gov.br/dados/serie/bcdata.sgs.1/dados?formato=json',
#                        '7' = 'http://api.bcb.gov.br/dados/serie/bcdata.sgs.7/dados?formato=json'))
# })

# test_that("it should create named urls for named codes", {
#   urls = series_url(c(USD = 1))
#   expect_equal(urls, c(USD = 'http://api.bcb.gov.br/dados/serie/bcdata.sgs.1/dados?formato=json'))
#   urls = series_url(c(USD = 1, IBOVESPA = 7))
#   expect_equal(urls, c(USD = 'http://api.bcb.gov.br/dados/serie/bcdata.sgs.1/dados?formato=json',
#                        IBOVESPA = 'http://api.bcb.gov.br/dados/serie/bcdata.sgs.7/dados?formato=json'))
# })

# test_that("it should should handle complications in names", {
#   urls = series_url(c(USD = 1, 7))
#   expect_equal(urls, c(USD = 'http://api.bcb.gov.br/dados/serie/bcdata.sgs.1/dados?formato=json',
#                        '7' = 'http://api.bcb.gov.br/dados/serie/bcdata.sgs.7/dados?formato=json'))
# })

