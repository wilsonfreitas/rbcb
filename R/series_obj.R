
.series_obj = function(code) {
  name_ = names(code)
  name_ = if (is.null(name_) || name_ == "") as.character(code) else name_
  env = list()
  env$name = name_
  env$code = as.numeric(code)
  if (is.na(env$code))
    stop("Invalid series code: ", code)
  structure(env, class = "series_obj")
}

series_obj = function(code, load_info = TRUE) {
  ser <- lapply(seq_along(code), function(ix) .series_obj(code[ix]))
  info <- if (load_info) lapply(ser, series_info) else rep(NA, length(ser))
  mapply(function(series, info) {
    series$info <- if (!is(info, "list")) NULL else info
    series
  }, ser, info, SIMPLIFY = FALSE, USE.NAMES = FALSE)
}