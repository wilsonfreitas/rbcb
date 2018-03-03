#' Get the series from BCB
#'
#' @param code series code
#' @param start_date series initial date. Accepts ISO character formated date and \code{Date}.
#' @param end_date series final date. Accepts ISO character formated date and \code{Date}.
#' @param last last items of the series
#' @param as the returning type: data objects (\code{tibble, xts, data.frame, ts}) or \code{text} for raw JSON
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
                       as = c('tibble', 'xts', 'ts', 'data.frame', 'text')) {
  as <- match.arg(as)
  objs = series_obj(code)

  series = lapply(objs, function(x) .get_series(series_url(x, start_date, end_date, last)))

  series = mapply(create_series, series, objs,
                  MoreArgs = list(as = as),
                  SIMPLIFY = FALSE,
                  USE.NAMES = FALSE)

  names_ = lapply(objs, function(x) x$name)
  series = setNames(series, names_)

  if (length(series) == 1)
    series[[1]]
  else
    series
}

.get_series = function(url) {
  res <- http_getter(url)
  if (res$status_code != 200) {
    stop("BCB API Request error, status code = ", res$status_code)
  }

  http_gettext(res)
}

create_series = function(json_, x, as) {
  if (as == 'text')
    return(json_)

  df_ <- jsonlite::fromJSON(json_)

  names(df_) <- resolve_names(names(df_))

  df_ = within(df_, {
    date <- as.Date(date, format = '%d/%m/%Y')
    if (exists("end_date"))
      end_date <- as.Date(end_date, format = '%d/%m/%Y')
    value <- as.numeric(value)
  })

  name_ <- x$name

  switch (as,
          'tibble' = {
            df_ <- tibble::as_tibble(df_)
            names(df_) <- set_series_name(names(df_), name_)
            df_
          },
          'data.frame' = {
            names(df_) <- set_series_name(names(df_), name_)
            df_
          },
          'xts' = {
            df_ <- xts::xts(df_$value, df_$date)
            names(df_) <- name_
            df_
          },
          'ts' = {
            freq = if (is.null(x$info$frequency)) 'D' else x$info$frequency
            freq_ = switch (freq,
                           'A' = 1,
                           'M' = 12,
                           'D' = 366
            )
            start = switch (freq,
              'A' = {
                as.integer(format(df_$date[1], '%Y'))
              },
              'M' = {
                c(
                  as.integer(format(df_$date[1], '%Y')),
                  as.integer(format(df_$date[1], '%m'))
                )
              },
              'D' = {
                c(
                  as.integer(format(df_$date[1], '%Y')),
                  as.integer(format(df_$date[1], '%j'))
                )
              }
            )
            stats::ts(df_$value, start = start, frequency = freq_)
          }
  )
}

resolve_names = function(nx) {
  ix = grep("^data$|^datafim$|^valor$", nx)
  nm = sapply(ix, function(ix) {
    nnx = sub("^data$", "date", nx[ix])
    if (nnx != nx[ix]) return(nnx)
    nnx = sub("^datafim$", "end_date", nx[ix])
    if (nnx != nx[ix]) return(nnx)
    nnx = sub("^valor$", "value", nx[ix])
    if (nnx != nx[ix]) return(nnx)
    nx[ix]
  }, USE.NAMES = FALSE)
  nx[ix] = nm
  nx
}

set_series_name = function(nx, nm) {
  ix = grep("^value$", nx)
  nx[ix] = nm
  nx
}