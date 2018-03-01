
.series_obj = function(code) {
  name_ = names(code)
  name_ = if (is.null(name_) || name_ == "") as.character(code) else name_
  env = list()
  env$name = name_
  env$code = as.numeric(code)
  structure(env, class = "series_obj")
}

series_obj = function(code) {
  ser = lapply(seq_along(code), function(ix) .series_obj(code[ix]))
  info = lapply(ser, series_info)
  mapply(function(series, info) {
    series$info = info
    series
  }, ser, info, SIMPLIFY = FALSE, USE.NAMES = FALSE)
}