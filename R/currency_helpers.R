#' Helpers to access time series columns
#'
#' Extraxt bid and ask data from time series objects.
#'
#' @param x time series objects containing data to be extracted
#' @param ... additional arguments
#'
#' @return tibble with time series
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
Bid.data.frame <- function(x, ...) {
  x_ <- subset(x, select = c('date', 'bid'))
  colnames(x_) <- c("date", attr(x, "symbol"))
  x_
}

#' @rdname helpers
#' @export
Bid.xts <- function(x, ...) {
  x_ <- x[,"bid"]
  colnames(x_) <- c(attr(x, "symbol"))
  x_
}

#' @rdname helpers
#' @export
Bid.olinda_df <- function(x, ...) {
  x_ <- subset(x, select = c("datetime", "bid"))
  colnames(x_) <- c("datetime", attr(x, "symbol"))
  x_
}

#' @rdname helpers
#' @export
Ask <- function(x, ...) UseMethod("Ask", x)

#' @rdname helpers
#' @export
Ask.data.frame <- function(x, ...) {
  x_ <- subset(x, select = c("date", "ask"))
  colnames(x_) <- c("date", attr(x, "symbol"))
  x_
}

#' @rdname helpers
#' @export
Ask.xts <- function(x, ...) {
  x_ <- x[,"ask"]
  colnames(x_) <- c(attr(x, "symbol"))
  x_
}

#' @rdname helpers
#' @export
Ask.olinda_df <- function(x, ...) {
  x_ <- subset(x, select = c("datetime", "ask"))
  colnames(x_) <- c("datetime", attr(x, "symbol"))
  x_
}
