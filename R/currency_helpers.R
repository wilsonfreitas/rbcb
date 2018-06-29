#' Helpers to access time series columns
#'
#' Extraxt bid and ask data from time series objects.
#'
#' @param x time series objects containing data to be extracted
#' @param ... additional arguments
#'
#' @name helpers
#' @examples
#' x <- get_currency("EUR", "2018-06-22", "2018-06-28")
#' Bid(x)
#' Ask(x)
NULL

#' @rdname helpers
#' @export
Bid <- function(x, ...) UseMethod("Bid")

#' @rdname helpers
#' @export
Bid.data.frame <- function(x, ...) subset(x, select = c('date', 'bid'))

#' @rdname helpers
#' @export
Bid.xts <- function(x, ...) x[,"bid"]

#' @rdname helpers
#' @export
Ask <- function(x, ...) UseMethod("Ask")

#' @rdname helpers
#' @export
Ask.data.frame <- function(x, ...) subset(x, select = c('date', 'ask'))

#' @rdname helpers
#' @export
Ask.xts <- function(x, ...) x[,"ask"]
