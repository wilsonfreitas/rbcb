
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
  env$code <- as.numeric(code)
  if (is.na(env$code)) {
    stop("Invalid series code: ", as.numeric(code))
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

  res <- http_getter(url)

  sgs_parse_info(x, http_gettext(res, encoding = "latin1", as = "text"))
}

sgs_parse_info <- function(x, txt) {
  doc <- read_html(txt)

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
#'        (default TRUE)
#'
#' @return an SGS object representing SGS codes
#' @examples
#' \dontrun{
#' sgs(USD = 1, IPCA = 433)
#' }
#' @export
sgs <- function(..., load_info = TRUE) {
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
#' @rdname rbcb_get
#' @examples
#' \dontrun{
#' x <- sgs(USD = 1, SELIC = 1178)
#' rbcb_get(x, from = "Sys.Date() - 10")
#' }
#' @export
rbcb_get.sgs <- function(x, from = NULL, to = NULL, last = 0, ...) {
  map_dfr(x, function(ser) {
    url <- sgs_url(ser, from, to, last)
    res <- http_getter(url)
    json <- http_gettext(res, as = "text")
    sgs_create_series(ser, json)
  })
}

sgs_create_series <- function(x, json) {
  df_ <- fromJSON(json)

  df_ <- within(df_, {
    data <- as.Date(data, format = "%d/%m/%Y")
    valor <- as.numeric(valor)
  })

  df_ <- df_[, c("data", "valor")]
  df_[["name"]] <- x$name
  names(df_) <- c("date", "value", "name")
  df_ <- as_tibble(df_)
  df_
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
  switch(as,
    "tibble" = {
      df <- df[, c("date", "value")]
      names(df) <- c("date", x$name)
      df
    },
    "data.frame" = {
      df <- as.data.frame(df[, c("date", "value")])
      names(df) <- c("date", x$name)
      df
    },
    "xts" = {
      df <- xts(df$value, df$date)
      colnames(df) <- x$name
      df
    },
    "ts" = {
      freq <- if (is.null(x$info$frequency)) "D" else x$info$frequency
      freq_ <- switch(freq,
        "A" = 1,
        "M" = 12,
        "D" = 366
      )
      start <- switch(freq,
        "A" = {
          as.integer(format(df$date[1], "%Y"))
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