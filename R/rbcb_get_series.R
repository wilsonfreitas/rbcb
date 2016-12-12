
#' @export
get_series <- function(code, start_date = NULL, end_date = NULL, last = 0, verbose = FALSE, as = c('tibble', 'xts', 'data.frame'), parse_fields = TRUE) {
  url <- series_url(code, start_date, end_date, last)
  res <- httr::GET(url, if (verbose) httr::verbose())
  if (res$status_code != 200) {
    # cnt <- httr::content(res, as = "text")
    stop("Request error, status code = ", res$status_code)
  }
  json_ <- httr::content(res, as = "text")
  df_ <- jsonlite::fromJSON(json_)

  if (parse_fields) {
    df_ <- within(df_, {
      data <- lubridate::dmy_hms(data)
      valor <- as.numeric(valor)
    })
  }

  as <- match.arg(as)
  if (as == 'tibble')
    df_ <- tibble::as_tibble(df_)
  else if (as == 'xts') {
    df_ <- xts::xts(df_$valor, df_$data)
    names(df_) <- code
  }

  df_
}
