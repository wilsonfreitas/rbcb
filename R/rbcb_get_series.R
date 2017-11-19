#' Get the series from BCB
#'
#' @param code series code
#' @param start_date series initial date. Accepts ISO character formated date and \code{Date}.
#' @param end_date series final date. Accepts ISO character formated date and \code{Date}.
#' @param last last items of the series
#' @param name series name to be used in the returning object
#' @param as the returning type: data objects (\code{tibble, xts, data.frame, ts}) or \code{text} for raw JSON
#' @param ts_options options to be passed to \code{ts} function (when \code{as = 'ts'} provided)
#'
#' \code{code} argument can be obtained in the SGS system site. In this site searches can be executed in
#' order to find out the desired series and use the series code in the \code{code} argument.
#'
#' The arguments \code{start_date}, \code{end_date} and \code{last} are optional.
#' If none of these arguments are set, then the entire time series is downloaded.
#' Define \code{start_date} and \code{end_date} to download a period of data and to
#' download the last \code{N} registers define the \code{last} argument to \code{N}
#' a positive integer.
#' Once \code{last} is provided it overrides the arguments \code{start_date} and \code{end_date}.
#'
#' If \code{name} argument is set the returning series is properly named, if not the code argument is used.
#' Note that the code is \code{numeric}.
#'
#'
#' @return
#' \code{tibble} is the default returning class, but the argument \code{as} can be set
#' to \code{xts}, \code{data.frame}, \code{ts}, or \code{text} to return these other types.
#' \code{text} returns the JSON data provided by the remote API.
#'
#' @examples
#' # download the entire series
#' \dontrun{get_series(1)}
#' # download a period of dates
#' \dontrun{get_series(1, start_date = '2016-12-01')}
#' \dontrun{x <- get_series(1, start_date = '2016-12-01', end_date = '2016-12-31')}
#' # downlaod the last register
#' x <- get_series(1, last = 1)
#'
#' @export
get_series <- function(code, start_date = NULL, end_date = NULL, last = 0,
                       name = NULL,
                       as = c('tibble', 'xts', 'ts', 'data.frame', 'text'), ts_options = NULL) {
  as <- match.arg(as)
  url <- series_url(code, start_date, end_date, last)
  res <- http_getter(url)
  if (res$status_code != 200) {
    stop("BCB API Request error, status code = ", res$status_code)
  }
  # json_ <- httr::content(res, as = "text")
  json_ <- http_gettext(res)

  if (as == 'text')
    return(json_)

  df_ <- jsonlite::fromJSON(json_)
  names(df_) <- c('date', 'value')

  df_ <- within(df_, {
    date <- as.Date(date, format = '%d/%m/%Y')
    value <- as.numeric(value)
  })

  name_ <- if (is.null(name)) code else name

  switch (as,
    'tibble' = {
      df_ <- tibble::as_tibble(df_)
      names(df_) <- c('date', name_)
      df_
    },
    'data.frame' = {
      names(df_) <- c('date', name_)
      df_
    },
    'xts' = {
      df_ <- xts::xts(df_$value, df_$date)
      names(df_) <- name_
      df_
    },
    'ts' = {
      do.call(stats::ts, append(list(data = df_$value), ts_options))
    }
  )

  # if (as == 'tibble') {
  #   df_ <- tibble::as_tibble(df_)
  #   names(df_) <- c('date', name_)
  # } else if (as == 'data.frame') {
  #   names(df_) <- c('date', name_)
  # } else if (as == 'xts') {
  #   df_ <- xts::xts(df_$value, df_$date)
  #   names(df_) <- name_
  # } else if (as == 'ts') {
  #   df_ <- do.call(stats::ts, append(list(data = df_$value), ts_options))
  # }
  #
  #   df_
}
