#' R interface to Brazilian Central Bank RESTful API
#'
#' The Brazilian Central Bank API delivers many datasets which regard economic
#' activity, regional economy, international economy, public finances, credit
#' indicators and many more.
#' These datasets can be accessed through \code{rbcb} functions and can be obtained in
#' different data structures common to R (tibble, data.frame, xts, ...).
#'
#' @name rbcb-package
#' @docType package
#'
#' @importFrom httr GET POST verbose add_headers status_code content modify_url
#' @importFrom httr parse_url headers
#' @importFrom jsonlite fromJSON
#' @importFrom utils read.table
#' @importFrom stats ts setNames
#' @importFrom xts xts
#' @importFrom xml2 read_html xml_find_all xml_attr xml_text xml_find_first
#' @importFrom methods is
#' @importFrom tibble tibble as_tibble
#' @importFrom purrr map map_dfr
#'
NULL