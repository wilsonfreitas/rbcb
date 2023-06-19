http_getter <- function(url, verbose = getOption("rbcb_verbose", default = FALSE)) {
  h <- handle("")
  res <- GET(
    url = url,
    config = list(),
    handle = h,
    if (verbose) verbose()
  )
  if (status_code(res) != 200) {
    msg <- sprintf("Request error %s\n", status_code(res))
    stop(msg, "URL:", url)
  } else {
    res
  }
}

http_poster <- function(url, body, encode = "form", verbose = getOption("rbcb_verbose", default = FALSE)) {
  res <- POST(
    url = url,
    config = list(),
    body = body,
    encode = encode,
    if (verbose) verbose()
  )
  if (status_code(res) != 200) {
    msg <- sprintf("Request error %s\n", status_code(res))
    stop(msg, "URL:", url)
  } else {
    res
  }
}

http_gettext <- function(res, encoding = "UTF-8", as = "raw") {
  x <- content(res, as = as, encoding = encoding)
  if (as == "raw") {
    iconv(rawToChar(x),from=encoding)
  } else {
    x
  }
}

http_download <- function(method = c("get", "post"), ...) {
  method <- match.arg(method)
  cache <- getOption("rbcb_cache", default = TRUE)
  params <- list(...)
  code <- digest(params)
  dest <- file.path(tempdir(), code)

  if (cache && file.exists(dest)) {
    message("Skipping download - using cached version")
    return(dest)
  }

  res <- if (method == "get") {
    http_getter(...)
  } else {
    http_poster(...)
  }

  bin <- content(res, as = "raw")
  writeBin(bin, dest)

  dest
}

#' rbcb options
#'
#' Options used in rbcb inside some of its functions.
#'
#' * `rbcb_cache`: all downloaded data is stored in temporary directories,
#'   if `rbcb_cache` is FALSE downloaded data overwrites files if it already
#'   exists. Otherwise, download is not executed and the existing file is
#'   returned. Defaults to TRUE.
#' * `rbcb_verbose`: if TRUE verbose messages are displayed when http requests
#'   are executed with httr. Defaults to FALSE.
#'
#' @name rbcb-options
#'
#' @examples
#' \dontrun{
#' options(rbcb_cache = FALSE)
#' options(rbcb_verbose = TRUE)
#' }
NULL
