
sgs_obj <- function(code, load_info = TRUE) {
  name_ <- names(code)
  name_ <- if (is.null(name_) || name_ == "") {
    unamed <- TRUE
    as.character(code)
  } else {
    unamed <- FALSE
    name_
  }
  env <- list()
  env$unamed <- unamed
  env$name <- name_
  env$code <- suppressWarnings(as.numeric(code))
  if (is.na(env$code) || env$code < 1) {
    stop("Invalid series code: ", code)
  }
  env$info <- if (load_info) sgs_info(env) else NULL
  structure(env, class = "sgs_obj")
}

sgs_url <- function(x, from = NULL, to = NULL, last = 0) {
  code <- x$code
  query <- list(formato = "json")
  url <- if (last == 0) {
    from_date <- if (!is.null(from)) as.Date(from) else as.Date("1900-01-01")
    query$dataInicial <- format(from_date, "%d/%m/%Y")

    to_date <- if (!is.null(to)) as.Date(to) else Sys.Date()
    query$dataFinal <- format(to_date, "%d/%m/%Y")

    sprintf("https://api.bcb.gov.br/dados/serie/bcdata.sgs.%d/dados", code)
  } else {
    sprintf(
      "https://api.bcb.gov.br/dados/serie/bcdata.sgs.%d/dados/ultimos/%d",
      code, last
    )
  }
  modify_url(url, query = query)
}

sgs_info <- function(x) {
  url <- "https://www3.bcb.gov.br/sgspub/consultarvalores/consultarValoresSeries.do?method=consultarGraficoPorId"
  url <- modify_url(url, query = list(hdOidSeriesSelecionadas = x$code))

  f <- http_download("get", url)

  sgs_parse_info(x, f)
}

sgs_parse_info <- function(x, f) {
  doc <- read_html(f, encoding = "latin1")

  info <- xml_find_first(doc, '//tr[@class="fundoPadraoAClaro3"]')
  if (length(info) == 0) {
    stop("BCB SGS error: code ", x$code, " returned no info")
  }

  info <- xml_find_all(info, ".//td")
  info <- xml_text(info)
  if (length(info) == 1) {
    stop("BCB SGS error: code ", x$code, " returned no info")
  }

  info <- as.list(info[-length(info)])
  cn <- c("code", "description", "unit", "frequency", "from", "to")
  info <- setNames(info, cn)

  info$from <- as.Date(info$from, "%d/%m/%Y")
  info$to <- as.Date(info$to, "%d/%m/%Y")

  info
}

#' Create SGS code
#'
#' SGS code is an objects that represents the SGS code used to download
#' datasets from the SGS API.
#'
#' @param ... numeric codes (preferably named)
#' @param load_info `logical` indicating with the dataset info shoud be loaded
#'        (default FALSE). The info is scraped from the SGS website, which is
#'        often unavailable.
#'
#' @return an SGS object representing SGS codes
#' @examples
#' \dontrun{
#' sgs(USD = 1, IPCA = 433)
#' }
#' @export
sgs <- function(..., load_info = FALSE) {
  codes <- list(...)
  objs <- lapply(seq_along(codes), function(ix) {
    sgs_obj(codes[ix], load_info)
  })
  names(objs) <- lapply(objs, function(x) x$name)
  structure(objs, class = "sgs")
}

print.sgs_obj <- function(x, ...) {
  name <- if (x$unamed) {
    paste0("`", x$name, "`")
  } else {
    x$name
  }
  cat("\n-- SGS Series:", name, "\n")
  cat("Code:", x$code, "\n")
  if (!is.null(x$info)) {
    cat("Description:", x$info$description, "\n")
    cat("From:", format(x$info$from), "\n")
    cat("To:", format(x$info$to), "\n")
    cat("Frequency:", x$info$frequency, "\n")
    cat("Unit:", x$info$unit, "\n")
  }
  invisible(x)
}

print.sgs <- function(x, ...) {
  lapply(x, print.sgs_obj)
  invisible(x)
}

#' @param from series initial date. Accepts ISO character formated date and
#'        \code{Date}.
#' @param to series final date. Accepts ISO character formated date and
#'        \code{Date}.
#' @param last last items of the series
#'
#' To use the SGS API a `sgs` object should be passed.
#'
#' Series that return a period for each value (e.g. TR 226, TBF 253) have an
#' extra `enddate` column with the end of the period.
#'
#' @rdname rbcb_get
#' @examples
#' \dontrun{
#' x <- sgs(USD = 1, SELIC = 1178)
#' rbcb_get(x, from = Sys.Date() - 10)
#' }
#' @export
rbcb_get.sgs <- function(x, from = NULL, to = NULL, last = 0, ...) {
  map_dfr(x, function(ser) {
    files <- sgs_download(ser, from, to, last)
    map_dfr(files, function(f) sgs_create_series(ser, f))
  })
}

# Daily series accept at most a 10-year window (HTTP 406). On 406 the range is
# downloaded in 10-year windows, from `to` back to `from` or to the first empty
# window (HTTP 404), which marks the start of the series.
sgs_download <- function(x, from, to, last) {
  if (last != 0) {
    return(http_download("get", sgs_url(x, last = last)))
  }
  tryCatch(
    http_download("get", sgs_url(x, from, to)),
    rbcb_http_error = function(e) {
      if (e$status != 406) stop(e)
      sgs_download_windows(x, from, to)
    }
  )
}

sgs_download_windows <- function(x, from, to) {
  from <- if (is.null(from)) as.Date("1900-01-01") else as.Date(from)
  end <- if (is.null(to)) Sys.Date() else as.Date(to)
  files <- character(0)
  while (end >= from) {
    start <- max(from, seq(end, by = "-10 years", length.out = 2)[2] + 1)
    f <- tryCatch(
      http_download("get", sgs_url(x, start, end)),
      rbcb_http_error = function(e) if (e$status == 404) NULL else stop(e)
    )
    if (is.null(f)) break
    files <- c(f, files)
    end <- start - 1
  }
  if (length(files) == 0) {
    stop("BCB SGS: no data for code ", x$code, " in the requested period")
  }
  files
}

# Raw JSON of one series; the 10-year windows are joined into one JSON array.
sgs_json <- function(x, from, to, last) {
  txt <- vapply(sgs_download(x, from, to, last), function(f) {
    paste(readLines(f, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
  }, "", USE.NAMES = FALSE)
  if (length(txt) == 1) {
    return(txt)
  }
  inner <- sub("(?s)^\\s*\\[(.*)\\]\\s*$", "\\1", txt, perl = TRUE)
  paste0("[", paste(inner[nzchar(trimws(inner))], collapse = ","), "]")
}

# Period series (TR 226, TBF 253) also return `dataFim`; keep it as `enddate`.
sgs_create_series <- function(x, json) {
  df_ <- fromJSON(json)
  out <- tibble(date = as.Date(df_$data, format = "%d/%m/%Y"))
  if (!is.null(df_$dataFim)) {
    out$enddate <- as.Date(df_$dataFim, format = "%d/%m/%Y")
  }
  out$value <- as.numeric(df_$valor)
  out$name <- x$name
  out
}

#' Convert tidy dataframe into a list
#'
#' Convert a tidy dataframe into a list of separate time series objects like
#' `xts` and `ts` or even a `tibble` with a time series representation (
#' two columns with dates and values).
#'
#' @param x sgs object with the corresponding codes
#' @param tidydf tidy dataframe returned by `rbcb_get`
#' @param as the returning type (`tibble`, `xts`, `ts`)
#'
#' @return a list with time series objects
#'
#' @examples
#' \dontrun{
#' x <- sgs(USD = 1, SELIC = 1178)
#' df <- rbcb_get(x, from = Sys.Date() - 10)
#' sgs_untidy(x, df, as = "xts")
#' }
#' @export
sgs_untidy <- function(x, tidydf, as = c("tibble", "xts", "ts")) {
  as <- match.arg(as)
  .sgs_convert_series(x, tidydf, as)
}

.sgs_convert_series <- function(x, tidy_df, as) {
  series_g <- split(tidy_df, tidy_df$name)
  df_g <- map(names(series_g), function(name) {
    x_ <- x[[name]]
    df_ <- series_g[[name]]
    .sgs_convert_split(x_, df_, as)
  })
  if (length(df_g) == 1) {
    df_g[[1]]
  } else {
    names(df_g) <- names(series_g)
    df_g
  }
}

.sgs_convert_split <- function(x, df, as) {
  has_end <- "enddate" %in% names(df) && !all(is.na(df$enddate))
  cols <- if (has_end) c("date", "enddate", "value") else c("date", "value")
  if (has_end && as %in% c("xts", "ts") && anyDuplicated(df$date)) {
    stop("Series ", x$name, " has periods that share a start date; ",
      "use as = \"tibble\" or \"data.frame\" to keep the end date",
      call. = FALSE
    )
  }
  switch(as,
    "tibble" = {
      df <- df[, cols]
      names(df) <- c(cols[-length(cols)], x$name)
      df
    },
    "data.frame" = {
      df <- as.data.frame(df[, cols])
      names(df) <- c(cols[-length(cols)], x$name)
      df
    },
    "xts" = {
      df <- xts(df$value, df$date)
      colnames(df) <- x$name
      df
    },
    "ts" = {
      freq <- .sgs_infer_frequency(df$date)
      freq_ <- switch(freq,
        "A" = 1,
        "Q" = 4,
        "M" = 12,
        "D" = 366
      )
      start <- switch(freq,
        "A" = {
          as.integer(format(df$date[1], "%Y"))
        },
        "Q" = {
          c(
            as.integer(format(df$date[1], "%Y")),
            as.integer(format(df$date[1], "%m")) %/% 3L + 1L
          )
        },
        "M" = {
          c(
            as.integer(format(df$date[1], "%Y")),
            as.integer(format(df$date[1], "%m"))
          )
        },
        "D" = {
          c(
            as.integer(format(df$date[1], "%Y")),
            as.integer(format(df$date[1], "%j"))
          )
        }
      )
      ts(df$value, start = start, frequency = freq_)
    }
  )
}
# Infer SGS frequency code from the typical gap between dates (in days).
# Gaps not matching A/Q/M (e.g. weekly) fall back to "D", as before.
.sgs_infer_frequency <- function(dates) {
  if (length(dates) < 2) {
    return("D")
  }
  gap <- stats::median(abs(diff(as.numeric(dates))))
  if (gap >= 360) "A" else if (gap >= 85) "Q" else if (gap >= 28) "M" else "D"
}
