
sgs_obj <- function(code, load_info = FALSE) {
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
    if (!is.null(from)) {
      query$dataInicial <- format(as.Date(from), "%d/%m/%Y")
    }
    if (!is.null(to)) {
      query$dataFinal <- format(as.Date(to), "%d/%m/%Y")
    }
    url <- sprintf(
      "http://api.bcb.gov.br/dados/serie/bcdata.sgs.%d/dados",
      code
    )
  } else {
    sprintf(
      "http://api.bcb.gov.br/dados/serie/bcdata.sgs.%d/dados/ultimos/%d",
      code, last
    )
  }
  httr::modify_url(url, query = query)
}

sgs_info <- function(x) {
  url <- "https://www3.bcb.gov.br/sgspub/consultarvalores/consultarValoresSeries.do?method=consultarGraficoPorId"
  url <- httr::modify_url(url, query = list(hdOidSeriesSelecionadas = x$code))

  res <- http_getter(url)
  if (httr::status_code(res) != 200) {
    msg <- sprintf(
      "BCB SGS Request error %s for code %s",
      httr::status_code(res),
      x$code
    )
    stop(msg)
  }

  sgs_parse_info(x, http_gettext(res, encoding = "latin1", as = "text"))
}

sgs_parse_info <- function(x, txt) {
  doc <- xml2::read_html(txt)

  info <- xml2::xml_find_first(doc, '//tr[@class="fundoPadraoAClaro3"]')
  if (length(info) == 0) {
    stop("BCB SGS error: code ", x$code, " returned no info")
  }

  info <- xml2::xml_find_all(info, ".//td")
  info <- xml2::xml_text(info)
  if (length(info) == 1) {
    stop("BCB SGS error: code ", x$code, " returned no info")
  }

  info <- as.list(info[-length(info)])
  cn <- c("code", "description", "unit", "frequency", "from", "to")
  info <- setNames(info, cn)

  info$url <- url
  info$from <- as.Date(info$from, "%d/%m/%Y")
  info$to <- as.Date(info$to, "%d/%m/%Y")

  info
}

sgs  <- function(..., load_info = FALSE) {
  codes <- list(...)
  series_codes <- lapply(seq_along(codes), function(ix) {
    sgs_obj(codes[ix], load_info)
  })
  structure(series_codes, class = "sgs")
}

print.sgs_obj <- function(x, ...) {
  cat("-- SGS Series --\n\n")
  cat("Code:       ", x$code, "\n")
  if (!is.null(x$info)) {
    cat("Description:", x$info$description, "\n")
    cat("From:       ", format(x$info$from), "\n")
    cat("To:         ", format(x$info$to), "\n")
    cat("Frequency:  ", x$info$frequency, "\n")
    cat("Unit:       ", x$info$unit, "\n")
    cat("SGS URL:    ", x$info$url, "\n")
  }
  invisible(x)
}

print.sgs <- function(x, ...) {
  pairs <- lapply(x, function(x) {
    if (x$unamed) {
      sprintf("%s", x$code)
    } else {
      sprintf("%s = %s", x$name, x$code)
    }
  })
  msg <- sprintf("<SGS Series: %s>", paste(pairs, collapse = ", "))
  cat(msg, "\n")
  invisible(x)
}

rbcb_get.sgs <- function(x, from = NULL, to = NULL, last = 0, ...) {
  series <- lapply(x, function(ser) {
    url <- sgs_url(ser, from, to, last)
    res <- http_getter(url)
    json <- http_gettext(res, as = "text")
    sgs_create_series(ser, json)
  })
  do.call(rbind, series)
}

sgs_create_series <- function(x, json) {
  df_ <- jsonlite::fromJSON(json)

  df_ <- within(df_, {
    data <- as.Date(data, format = "%d/%m/%Y")
    valor <- as.numeric(valor)
  })

  df_ <- df_[, c("data", "valor")]
  df_[["name"]] <- x$name
  names(df_) <- c("date", "value", "name")
  df_
}