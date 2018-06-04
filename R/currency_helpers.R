
#' @export
Bid <- function(x, ...) UseMethod("Bid")

#' @export
Bid.data.frame <- function(x) subset(x, select = c('date', 'bid'))

#' @export
Bid.xts <- function(x) x[,"bid"]

#' @export
Ask <- function(x, ...) UseMethod("Ask")

#' @export
Ask.data.frame <- function(x) subset(x, select = c('date', 'ask'))

#' @export
Ask.xts <- function(x) x[,"ask"]
