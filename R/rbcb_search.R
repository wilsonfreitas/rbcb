
number_of_pages <- function(doc) {
  node_pages <- xml2::xml_find_all(doc, '//div[@class="pagination pagination-centered"]/*/li/a')

  if (length(node_pages) > 0) {
    x <- sapply(node_pages, xml2::xml_text)
    x <- suppressWarnings( as.numeric(x) )
    max(x, na.rm = TRUE)
  } else {
    1
  }
}

#' @export
search_series <- function(q, page = 1) {
  url <- search_series_url(q, page = page)
  res <- httr::GET(url)

  doc <- xml2::read_html(httr::content(res, as = 'text'))

  nodes <- xml2::xml_find_all(doc, '//*[@class="dataset-item"]')

  nodes_pages <- xml2::xml_find_all(doc, '//div[@class="pagination"]')

  x <- lapply(nodes, function(x) {
    node <- xml2::xml_find_first(x, './/h3[@class="dataset-heading"]/a')
    a_ <- xml2::xml_attr(node, 'href')
    url <- httr::modify_url('http://dadosabertos.bcb.gov.br', path = a_)
    code <- stringr::str_match(a_, '/dataset/(\\d+)')[,2]
    title <- xml2::xml_text(node)
    node <- xml2::xml_find_first(x, './/*[@class="dataset-content"]/div')
    desc <- xml2::xml_text(node)
    structure(list(code = code, title = title, description = desc, url = url), class = "rbcb_search_result")
  })

  n <- number_of_pages(doc)

  structure(list(results = x, number_of_pages = n, page = page), class = "rbcb_search_results")
}

#' @export
print.rbcb_search_result <- function(x, ...) {
  cat("\n")
  cat("Dataset:", x$title, "\n")
  cat("Code:", x$code, "\n")
  cat(x$description, "\n")
  cat("URL:", x$url, "\n")
  invisible(x)
}

#' @export
print.rbcb_search_results <- function(x, ...) {
  lapply(x$results, print)
  cat('\n')
  cat(length(x$results), 'results', '\n')
  cat('Pagination', x$page, '/', x$number_of_pages, '\n')
  invisible(x)
}
