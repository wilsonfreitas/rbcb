#' R interface to Brazilian Central Bank RESTful API
#'
#' The Brazilian Central Bank API delivers many datasets which regard economic
#' activity, regional economy, international economy, public finances, credit
#' indicators and many more.
#' These datasets can be accessed through \code{rbcb} functions and can be obtained in
#' different data structures common to R (tibble, data.frame, xts, ...).
#'
#' @name rbcb
#' @docType package
#'
#' @import httr
#' @import jsonlite
#' @import xts
#' @import utils
#' @import stats
#' @import dplyr
#' @importFrom xml2 read_html xml_find_all xml_attr xml_text xml_find_first
#' @importFrom methods is
#' @importFrom tibble tibble as_tibble
#' @importFrom purrr map map_dfr
#'
NULL