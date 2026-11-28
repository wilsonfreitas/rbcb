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
#' \code{text} returns the JSON data provided by the remote API: one string for
#' one series, or a named list of strings for several series. Periods longer than
#' 10 years are joined into one JSON array.
#'
#' Series that return a period for each value (e.g. TR 226, TBF 253) have an
#' extra \code{enddate} column in \code{tibble} and \code{data.frame} output.
#' \code{xts} and \code{ts} are indexed by the start date only, and raise an
#' error when two periods share a start date.
#'
#' @examples
#' # download the entire series
#' \dontrun{
#' get_series(1)
#' }
#' # download a period of dates
#' \dontrun{
#' get_series(1, start_date = "2016-12-01")
#' }
#' \dontrun{
#' x <- get_series(1, start_date = "2016-12-01", end_date = "2016-12-31")
#' }
#' # downlaod the last register
#' \dontrun{
#' x <- get_series(1, last = 1)
#' }
#'
#' @export
get_series <- function(code, start_date = NULL, end_date = NULL, last = 0,
                       as = c("tibble", "xts", "ts", "data.frame", "text")) {
  as <- match.arg(as)
  sgs_args <- as.list(code)
  sgs_args$load_info <- FALSE
  objs <- do.call(sgs, sgs_args)

  if (as == "text") {
    txt <- lapply(objs, sgs_json, start_date, end_date, last)
    return(if (length(txt) == 1) txt[[1]] else txt)
  }

  df_tidy <- rbcb_get(objs, start_date, end_date, last)

  .sgs_convert_series(objs, df_tidy, as)
}