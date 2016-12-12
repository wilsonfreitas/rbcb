
series_url <- function(code, start_date = NULL, end_date = NULL, last = 0) {
  url <- if (last == 0) {
    sprintf('http://api.bcb.gov.br/dados/serie/bcdata.sgs.%d/dados', code)
  } else {
    sprintf('http://api.bcb.gov.br/dados/serie/bcdata.sgs.%d/dados/ultimos/%d', code, last)
  }
  query <- list(formato = 'json')
  httr::modify_url(url, query = query)
}

search_series_url <- function(q, page = 1) {
  url <- 'http://dadosabertos.bcb.gov.br/organization/b7509736-3cae-4a87-83f2-dee493f76afa'
  query <- list(res_format = 'JSON', q = q, page = page)
  httr::modify_url(url, query = query)
}

