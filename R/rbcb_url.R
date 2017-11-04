
series_url <- function(code, start_date = NULL, end_date = NULL, last = 0) {
  query <- list(formato = 'json')
  url <- if (last == 0) {
    if (!is.null(start_date) || !is.null(end_date)) {
      query$dataInicial <- if (is.null(start_date)) format(as.Date("1900-01-01"), '%d/%m/%Y') else format(as.Date(start_date), '%d/%m/%Y')
      query$dataFinal <- if (is.null(end_date)) format(Sys.Date(), '%d/%m/%Y') else format(as.Date(end_date), '%d/%m/%Y')
    }
    sprintf('http://api.bcb.gov.br/dados/serie/bcdata.sgs.%d/dados', code)
  } else {
    if (! is.null(start_date) || ! is.null(end_date))
      warning('Nonsense parameters: start_date or end_date provided together with last')
    sprintf('http://api.bcb.gov.br/dados/serie/bcdata.sgs.%d/dados/ultimos/%d', code, last)
  }
  httr::modify_url(url, query = query)
}

search_series_url <- function(q, page = 1) {
  url <- 'https://dadosabertos.bcb.gov.br/dataset'
  query <- list(res_format = 'JSON', q = q, page = page)
  httr::modify_url(url, query = query)
}

