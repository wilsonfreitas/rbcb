
# Moedas do Tipo "A":
#   - Para calcular o valor equivalente em US$ (dólar americano), divida o montante na moeda consultada pela respectiva paridade.
# - Para obter o valor em R$ (reais), multiplique o montante na moeda consultada pela respectiva taxa.
# Moedas do Tipo "B":
#   - Para calcular o valor equivalente em US$ (dólar americano), multiplique o montante na moeda consultada pela respectiva paridade.
# - Para obter o valor em R$ (reais), multiplique o montante na moeda consultada pela respectiva taxa.
#
# https://ptax.bcb.gov.br/ptax_internet/consultaBoletim.do?method=exibeFormularioConsultaBoletim
# http://www4.bcb.gov.br/pec/taxas/port/ptaxnpesq.asp?id=txcotacao
# https://ptax.bcb.gov.br/ptax_internet/consultaBoletim.do?method=gerarCSVFechamentoMoedaNoPeriodo&ChkMoeda=61&DATAINI=13/02/2017&DATAFIM=14/03/2017
# http://www4.bcb.gov.br/pec/taxas/batch/tabmoedas.asp?id=tabmoeda
# http://www4.bcb.gov.br/Download/fechamento/20170314.csv
# https://ptax.bcb.gov.br/ptax_internet/consultaBoletim.do?method=gerarCSVTodasAsMoedas&id=59989

currency_url <- function(id, start_date, end_date) {
  url <- "https://ptax.bcb.gov.br/ptax_internet/consultaBoletim.do?method=gerarCSVFechamentoMoedaNoPeriodo&ChkMoeda=%s&DATAINI=%s&DATAFIM=%s"
  start_date <- format(as.Date(start_date), "%d/%m/%Y")
  end_date <- format(as.Date(end_date), "%d/%m/%Y")
  sprintf(url, id, start_date, end_date)
}

.CACHE_ENV <- new.env()

clear_cache <- function() rm(list = ls(.CACHE_ENV), pos = .CACHE_ENV)

get_valid_currency_list <- function(date = Sys.Date()) {
  url2 <- sprintf("http://www4.bcb.gov.br/Download/fechamento/M%s.csv", format(date, "%Y%m%d"))
  res <- http_getter(url2)
  if (res$status_code == 200)
    return(res)
  else
    get_valid_currency_list(date - 1)
}

get_currency_list <- function() {
  if (exists("TEMP_FILE_CURRENCY_LIST", envir = .CACHE_ENV)) {
    message("Retrieving all currencies file from cache")
    return(get("TEMP_FILE_CURRENCY_LIST", envir = .CACHE_ENV))
  } else {
    res <- get_valid_currency_list()
    x <- http_gettext(res)

    df <- utils::read.table(text = x, sep = ";", header = TRUE, colClasses = "character")
    names(df) <- c("code", "name", "symbol", "country_code", "country_name", "type", "exclusion_date")

    df <- within(df, {
      name <- sub("^\\s+", "", sub("\\s+$", "", name))
      country_name <- sub("^\\s+", "", sub("\\s+$", "", country_name))
      symbol <- sub("^\\s+", "", sub("\\s+$", "", symbol))
      exclusion_date <- as.Date(exclusion_date, "%d/%m/%Y")
      code <- as.numeric(code)
      country_code <- as.numeric(country_code)
    })

    message("Caching all currencies file")
    .CACHE_ENV[["TEMP_FILE_CURRENCY_LIST"]] <- df
    return(df)
  }
}

currency_id_list <- function() {
  if (exists("TEMP_CURRENCY_ID_LIST", envir = .CACHE_ENV)) {
    message("Retrieving currency id list from cache")
    return(get("TEMP_CURRENCY_ID_LIST", envir = .CACHE_ENV))
  } else {
    url1 <- "https://ptax.bcb.gov.br/ptax_internet/consultaBoletim.do?method=exibeFormularioConsultaBoletim"
    res <- http_getter(url1)
    if (res$status_code != 200) {
      stop("BCB API Request error, status code = ", res$status_code)
    }
    x <- httr::content(res, as = "text", encoding = "ISO-8859-1")
    x <- xml2::read_html(x, encoding = "ISO-8859-1")
    y <- xml2::xml_find_all(x, "//select[@name='ChkMoeda']/option")
    y <- lapply(y, function(x) {
      data.frame(
        id = as.numeric(xml2::xml_attr(x, "value")),
        name = xml2::xml_text(x),
        stringsAsFactors = FALSE
      )
    })
    y <- do.call(rbind, y)
    message("Caching currency id list")
    .CACHE_ENV[["TEMP_CURRENCY_ID_LIST"]] <- y
    return(y)
  }
}

get_currency_id <- function(symbol) {
  id_list <- suppressMessages(currency_id_list())
  all_currencies <- suppressMessages(get_currency_list())
  x <- merge(id_list, all_currencies)
  max(x[x$symbol == symbol,]$id)
}

#' Get currency matrix from BCB
#'
#' The currency matrix has the currency cross rates for all currencies present in the BCB system.
#'
#' @param date reference date
#' @param ref reffers to \code{bid} or \code{ask} rates (default \code{ask})
#'
#' \code{date} is the reference date by which the currency rates must be downloaded.
#' \code{ref} defaults to \code{ask} and \code{bid} returns all currency cross rates calculated with bid rates.
#'
#' @return
#' A square \code{matrix} with \code{colnames} and \code{rownames} filled with currency symbols
#' The cells must be read as \code{ROW} in \code{COL}, for example, BRL (row) in USD (column) means Brazilian Reals in American Dollars.
#'
#' @examples
#' x <- get_currency_cross_rates("2017-03-10")
#' currencies <- c("USD", "BRL", "AUD", "EUR", "CAD")
#' x[currencies, currencies]
#'
#' @export
get_currency_cross_rates <- function(date, ref = c("ask", "bid")) {
  ref <- match.arg(ref)
  x <- get_all_currencies(date)
  cur_mats <- generate_currency_matrix(x)
  cur_mats[[ref]]
}

generate_currency_matrix <- function(x) {
  gen_ <- function(c1, ns) {
    cur_mat <- matrix(0, nrow = length(c1), ncol = length(c1))
    colnames(cur_mat) <- ns
    rownames(cur_mat) <- ns
    for (i in seq_along(c1)) cur_mat[,i] <- c1/c1[i]
    cur_mat
  }
  list(
    bid = gen_(c(1, x[["bid"]]), c("BRL", x[["symbol"]])),
    ask = gen_(c(1, x[["ask"]]), c("BRL", x[["symbol"]]))
  )
}

#' All currency values
#'
#' Gets all currency values
#'
#' @param date reference date
#'
#' @return
#' A \code{data.frame} with all currency values from the given date.
#' The currency rates come quoted in BRL.
#'
#' @examples
#' get_all_currencies("2017-03-10")
#'
#' @export
get_all_currencies <- function(date) {
  url <- "https://ptax.bcb.gov.br/ptax_internet/consultaBoletim.do?method=consultarBoletim"
  body <- list(
    RadOpcao = 2,
    DATAINI = format(as.Date(date), "%d/%m/%Y"),
    DATAFIM = "",
    ChkMoeda = 1
  )
  res <- http_poster(url, body = body, encode = "form")
  if (res$status_code != 200)
    stop("BCB API Request error")
  x <- httr::content(res, as = "text")
  # x <- http_gettext(res)
  m <- regexec("gerarCSVTodasAsMoedas&amp;id=(\\d+)", x)
  if (length(m[[1]]) == 1 && m[[1]] == -1)
    stop("BCB API Request error")
  id <- regmatches(x, m)[[1]][2]
  url2 <- "https://ptax.bcb.gov.br/ptax_internet/consultaBoletim.do?method=gerarCSVTodasAsMoedas&id=%s"
  url2 <- sprintf(url2, id)
  res <- http_getter(url2)
  if (res$status_code != 200)
    stop("BCB API Request error")
  # x <- httr::content(res, as = "text", encoding = "UTF-8")
  x <- http_gettext(res)
  df <- utils::read.table(text = x, sep = ";", header = FALSE, colClasses = "character")
  names(df) <- c("date", "code", "type", "symbol", "bid", "ask", "bid.USD", "ask.USD")
  df <- within(df, {
    date <- as.Date(date, "%d%m%Y")
    bid <- as.numeric(sub(",", ".", bid))
    ask <- as.numeric(sub(",", ".", ask))
  })

  df <- df[,c("date", "symbol", "bid", "ask")]

  tibble::as_tibble(df[order(df$symbol),])
}

#' List all currencies
#'
#' Lists all currencies and presents their name, symbol, numeric code, country name and county numeric code
#'
#' @return
#' A \code{data.frame} with information of all currencies
#'
#' @examples
#' list_currencies()
#'
#' @export
list_currencies <- function() {
  x <- suppressMessages(get_currency_list())
  tibble::as_tibble(x[is.na(x$exclusion_date),c("name", "code", "symbol", "country_name", "country_code")])
}

#' Get currency values for a given period
#'
#' Given a currency symbol and a time interval (in dates) this function returns the
#' bid and ask time series of currency rates.
#'
#' @param symbol currency symbol
#' @param start_date time interval initial date
#' @param end_date time interval last date
#' @param as the object's returning type
#'
#' The \code{symbol} argument is a three digits character which represents one currency.
#' The symbols can be obtained with \code{list_currencies}.
#'
#' The time series date range is defined by \code{start_date} and \code{end_date}.
#'
#' @return
#' The time series with the bid and ask currency rates regarding the given symbol quoted in BRL.
#' The default returning is a \code{tibble}-fashioned \code{data.frame} with
#' the three columns: \code{date}, \code{ask} and \code{bid}.
#' The \code{as} argument also accepts \code{data.frame} to return old fashioned data frames,
#' \code{xts} to return a xts object with two variables (bid and ask) and \code{text} which returns
#' the text content download from BCB site.
#'
#' @examples
#' get_currency("USD", "2017-03-01", "2017-03-10")
#'
#' @export
get_currency <- function(symbol, start_date, end_date, as = c('tibble', 'xts', 'data.frame', 'text')) {
  as <- match.arg(as)
  id <- get_currency_id(symbol)
  url <- currency_url(id, start_date, end_date)
  res <- http_getter(url)
  if (res$status_code != 200) {
    stop("BCB API Request error, status code = ", res$status_code)
  }
  if (grepl("text/html", httr::headers(res)[['content-type']])) {
    # x <- httr::content(res, as = 'text')
    x <- http_gettext(res)
    x <- xml2::read_html(x)
    x <- xml2::xml_find_first(x, "//div[@class='msgErro']")
    stop("BCB API returned error: ", xml2::xml_text(x))
  }
  csv_ <- http_gettext(res)

  if (as == 'text')
    return(csv_)

  df_ <- utils::read.table(text = csv_, sep = ";", header = FALSE, colClasses = "character")
  names(df_) <- c("date", "aa", "bb", "cc", "bid", "ask", "dd", "ee")
  df <- within(df_, {
    date <- as.Date(date, format("%d%m%Y"))
    bid <- as.numeric(sub(",", ".", bid))
    ask <- as.numeric(sub(",", ".", ask))
  })

  df <- df[,c("date", "bid", "ask")]

  if (as == 'tibble') {
    df <- tibble::as_tibble(df)
  } else if (as == 'xts') {
    df <- xts::xts(df[,-1], df$date)
  }

  df
}

