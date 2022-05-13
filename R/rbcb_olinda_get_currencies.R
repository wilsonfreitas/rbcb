
# Moedas do Tipo "A": cotação == moeda / USD (CAD, CHF, DKK, JPY, NOK, SEK, USD)
#   - Para calcular o valor equivalente em US$ (dólar americano), divida o
#     montante na moeda consultada pela respectiva paridade.
#   - Para obter o valor em R$ (reais), multiplique o montante na moeda
#     consultada pela respectiva taxa.
# Moedas do Tipo "B": cotação == USD / moeda (AUD, EUR, GBP)
#   - Para calcular o valor equivalente em US$ (dólar americano), multiplique o
#     montante na moeda consultada pela respectiva paridade.
#   - Para obter o valor em R$ (reais), multiplique o montante na moeda
#     consultada pela respectiva taxa.

olinda_currency_url <- function(symbol, start_date, end_date) {
  start_date <- format(as.Date(start_date), "%m/%d/%Y")
  end_date <- format(as.Date(end_date), "%m/%d/%Y")
  url <- "https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/CotacaoMoedaPeriodo(moeda=@moeda,dataInicial=@dataInicial,dataFinalCotacao=@dataFinalCotacao)?%%40moeda='%s'&%%40dataInicial='%s'&%%40dataFinalCotacao='%s'"
  sprintf(url, symbol, start_date, end_date)
}


olinda_usd_url <- function(start_date, end_date) {
  start_date <- format(as.Date(start_date), "%m/%d/%Y")
  end_date <- format(as.Date(end_date), "%m/%d/%Y")
  url <- "https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/CotacaoDolarPeriodo(dataInicial=@dataInicial,dataFinalCotacao=@dataFinalCotacao)?%%40dataInicial='%s'&%%40dataFinalCotacao='%s'"
  sprintf(url, start_date, end_date)
}


#' List all currencies
#'
#' Lists all currencies and presents their name, symbol, numeric code, country name and county numeric code
#'
#' @return
#' A \code{data.frame} with information of all currencies.
#'
#' The \code{currency_type} refers to the currency's parity quotation.
#' Parity quotations relates currency values with USD.
#'
#' @examples
#' \dontrun{
#' list_currencies()
#' }
#'
#' @export
olinda_list_currencies <- function() {
  url <- "https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/Moedas"
  res <- GET(url)
  data <- fromJSON(content(res, as = "text"))
  df <- data$value
  names(df) <- c("symbol", "name", "currency_type")
  df
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
#' @param parity \code{TRUE} returns the parity quotation (default \code{FALSE}
#' currency quoted in BRL)
#'
#' The \code{symbol} argument is a three digits character which represents one currency.
#' The symbols can be obtained with \code{list_currencies}.
#'
#' The time series date range is defined by \code{start_date} and \code{end_date}.
#' If \code{end_date} is not passed, it is set equals to \code{start_date}.
#'
#' The \code{parity} argument defaults to \code{FALSE}, which means that the returned data is quoted in BRL.
#' If it is \code{TRUE} the returned data is quoted in USD, for type A currencies and for type B currencies it is
#' quoted as 1 USD in CURRENCY. For example, AUD, which is type B, returns 1 USD in AUD.
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
#' \dontrun{
#' olinda_get_currency("USD", "2017-03-01", "2017-03-10")
#' }
#'
#' @export
olinda_get_currency <- function(symbol, start_date, end_date = NULL,
                                as = c("tibble", "xts", "data.frame", "text"),
                                parity = FALSE) {
  as <- match.arg(as)
  if (is.null(end_date)) {
    end_date <- start_date
  }
  url <- olinda_currency_url(symbol, start_date, end_date)
  res <- http_getter(url)
  if (res$status_code != 200) {
    stop("BCB API Request error, status code = ", res$status_code)
  }

  text_ <- content(res, as = "text")

  if (as == "text") {
    return(text_)
  }

  data_ <- fromJSON(text_)
  df_ <- data_$value

  if (length(df_) == 0) {
    stop(
      "The selected range returned no results: start_date = ",
      format(start_date),
      ", end_date = ", format(end_date)
    )
  }

  names(df_) <- c("bid_parity", "ask_parity", "bid", "ask", "datetime", "type")
  df <- within(df_, {
    datetime <- as.POSIXct(datetime, tz = "America/Sao_Paulo")
  })

  if (parity) {
    df <- df[, c("datetime", "bid_parity", "ask_parity")]
    names(df) <- c("datetime", "bid", "ask")
  } else {
    df <- df[, c("datetime", "bid", "ask")]
  }

  if (as == "tibble") {
    df <- as_tibble(df)
  } else if (as == "xts") {
    df <- xts(df[, c(-1)], df$date)
  }

  if (is(df, "data.frame")) {
    class(df) <- c("olinda_df", class(df))
  }
  attr(df, "symbol") <- symbol

  df
}