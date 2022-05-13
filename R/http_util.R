
http_getter <- function(url, verbose = getOption("rbcb_verbose", default = FALSE)) {
  res <- GET(
    url = url,
    config = list(),
    if (verbose) verbose(),
    add_headers("User-Agent" = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.89 Safari/537.36")
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
    if (verbose) verbose(),
    add_headers("User-Agent" = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.89 Safari/537.36")
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
    rawToChar(x)
  } else {
    x
  }
}