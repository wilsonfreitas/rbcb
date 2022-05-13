#' Gets data from BCB open data services
#'
#' Gets SGS, currency, market expectations and many other datasets
#' from the Brazilian Central Bank open data services.
#'
#' @param x an object that represents the kind of data to be downloaded
#' @param ... others arguments
#'
#' @return a dataset with the corresponding data (usually a `tibble`)
#' @export
rbcb_get <- function(x, ...) {
  UseMethod("rbcb_get")
}