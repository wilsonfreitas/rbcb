
http_getter <- function(url, verbose = getOption("rbcb_verbose", default = FALSE)) {
  httr::GET(url = url,
            config = list(),
            if (verbose) httr::verbose(),
            httr::add_headers('User-Agent' = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.89 Safari/537.36'))
}

http_poster <- function(url, body, encode = "form", verbose = getOption("rbcb_verbose", default = FALSE)) {
  httr::POST(url = url,
             config = list(),
             body = body,
             encode = encode,
             if (verbose) httr::verbose(),
             httr::add_headers('User-Agent' = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.89 Safari/537.36'))
}

http_gettext <- function(res, encoding = "UTF-8") {
  x <- httr::content(res, as = "raw", encoding = encoding)
  rawToChar(x)
}
