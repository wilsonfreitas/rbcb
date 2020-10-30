
context('Search series')

test_that('should check if encoding is ok', {
  x <- search_series("IPCA")

  expect_equal(x[[1]][[1]]$title,
               "Índice de Preços ao Consumidor-Amplo (IPCA) - Não comercializáveis")
})
