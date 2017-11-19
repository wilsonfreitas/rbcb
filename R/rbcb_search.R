
#'
#' Search for series in dadosabertos.bcb.gov.br site
#'
#' @param q query string
#' @param page page number to visualize of returning search
#'
#' The \code{page} argument defaults to 1 which shows the first page of a returning search.
#' The search results also show the number of pages and the other pages can be showed by changing
#' this argument to the page to be presented.
#'
#' @return Display the search results on the screen
#'
#' @examples
#' search_series("IPCA")
#'
#' @export
search_series <- function(q, page = 1) {
  url <- search_series_url(q, page = page)
  res <- http_getter(url)

  # x <- httr::content(res, as = 'text')
  x <- http_gettext(res)
  doc <- xml2::read_html(x)

  nodes <- xml2::xml_find_all(doc, '//*[@class="dataset-item"]')

  nodes_pages <- xml2::xml_find_all(doc, '//div[@class="pagination"]')

  x <- lapply(nodes, function(x) {
    node <- xml2::xml_find_first(x, './/h3[@class="dataset-heading"]/a')
    a_ <- xml2::xml_attr(node, 'href')
    url <- httr::modify_url('http://dadosabertos.bcb.gov.br', path = a_)
    m <- regexec('/dataset/(\\d+)', a_)
    code <- regmatches(a_, m)[[1]][2]
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

