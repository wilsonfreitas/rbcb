
# indic = c("IGP-DI",
#           "IGP-M",
#           "INPC",
#           "IPA-DI",
#           "IPA-M",
#           "IPCA",
#           "IPCA-15",
#           "IPC-Fipe",
#           "Produção industrial",
#           "Meta para taxa over-selic",
#           "Taxa de câmbio")
#
# Data - date
# Indicador - indic
# DataReferencia - refdate
# Media - mean
# Mediana - median
# DesvioPadrao - sd
# CoeficienteVariacao - coefvar
# Minimo - min
# Maximo - max

#' Get monthly market expectations for the most relevant economic indicators
#'
#' Statistics for the monthly expectations of economic indicators: mean, median, standard
#' deviate, minimum, maximum and the coefficient of variation.
#' All statistics are computed based on monthly expectations provided by many financial
#' institutions in Brazil: banks, funds, risk managers, so on and so forth.
#' These expections and its statistics are used to build the FOCUS Report weekly
#' released by the Brazilian Central Bank.
#'
#' @param indic a character vector with economic indicators names: IGP-DI,
#' IGP-M, INPC, IPA-DI, IPA-M, IPCA, IPCA-15, IPC-Fipe, Produção industrial,
#' Meta para taxa over-selic, Taxa de câmbio. It's case sensitive and don't forget
#' the accents.
#' @param start_date series initial date. Accepts ISO character formated date and \code{Date}.
#' @param end_date series final date. Accepts ISO character formated date and \code{Date}.
#' @param ... additional parameters to be passed to the API
#'
#' \code{indic} argumento must be one of these: IGP-DI,
#' IGP-M, INPC, IPA-DI, IPA-M, IPCA, IPCA-15, IPC-Fipe, Produção industrial,
#' Meta para taxa over-selic, Taxa de câmbio. Respecting the case, blank spaces and
#' accents.
#'
#' The \code{...} is to be used with API's parameters. \code{$top} to specify
#' the maximum number of rows to be returned, this returns the \code{$top} rows,
#' in chronological order. There is also \code{$skip} to ignore the first rows.
#'
#' @return
#' A \code{data.frame} with the following nine columns: \code{date}, \code{indic},
#' \code{refdate}, \code{mean}, \code{median}, \code{sd}, \code{coefvar},
#' \code{min}, \code{max}.
#'
#' @examples
#' indic <- c("IPCA", "Produção industrial")
#' end_date <- "2018-01-31"
#' x <- get_monthly_market_expectations(indic, end_date = end_date, `$top` = 10)
#'
#' @export
get_monthly_market_expectations <- function(indic, start_date = NULL, end_date = NULL, ...) {
  valid_indic = c("IGP-DI",
                  "IGP-M",
                  "INPC",
                  "IPA-DI",
                  "IPA-M",
                  "IPCA",
                  "IPCA-15",
                  "IPC-Fipe",
                  "Produção industrial",
                  "Meta para taxa over-selic",
                  "Taxa de câmbio")

  check_indic <- indic %in% valid_indic
  if (!all(check_indic))
    stop("Invalid indic argument: ", paste(indic[!check_indic], collapse = ", "))

  url <- monthly_market_expectations_url(indic, start_date, end_date, ...)

  res <- httr::GET(url)

  text_ <- httr::content(res, as = "text")

  data_ <- jsonlite::fromJSON(text_)

  df_ <- tibble::as_tibble(data_$value)
  names(df_) <- c("indic", "date", "refdate", "mean", "median", "sd", "coefvar", "min", "max")

  df_$date <- as.Date(df_$date)
  df_$refdate <- as.Date(paste0("01", df_$refdate), "%d%m/%Y")

  df_
}

monthly_market_expectations_url <- function(indic, start_date, end_date, ...) {
  indic_filter <- paste(sprintf("Indicador eq '%s'", indic), collapse = " or ")

  sd_filter <- if (!is.null(start_date)) sprintf("Data ge '%s'", start_date) else NULL

  ed_filter <- if (!is.null(end_date)) sprintf("Data le '%s'", end_date) else NULL

  filter__ <- paste(c(indic_filter, sd_filter, ed_filter), collapse = " and ")

  httr::modify_url("https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/odata/ExpectativaMercadoMensais",
                   query = list(`$filter` = filter__,
                                `$format` = "application/json",
                                `$orderby` = "Data desc",
                                `$select` = "Indicador,Data,DataReferencia,Media,Mediana,DesvioPadrao,CoeficienteVariacao,Minimo,Maximo", ...))
}