
#' Get monthly market expectations of economic indicators
#'
#' Statistics for the monthly expectations of economic indicators: mean, median, standard
#' deviate, minimum, maximum and the coefficient of variation.
#' All statistics are computed based on monthly expectations provided by many financial
#' institutions in Brazil: banks, funds, risk managers, so on and so forth.
#' These expections and its statistics are used to build the FOCUS Report weekly
#' released by the Brazilian Central Bank.
#'
#' There are monthly expectations available for the following indicators: IGP-DI,
#' IGP-M, INPC, IPA-DI, IPA-M, IPCA, IPCA-15, IPC-Fipe, Produção industrial,
#' Meta para taxa over-selic, Taxa de câmbio.
#'
#' @param indic a character vector with economic indicators names: IGP-DI,
#' IGP-M, INPC, IPA-DI, IPA-M, IPCA, IPCA-15, IPC-Fipe, Produção industrial,
#' Meta para taxa over-selic, Taxa de câmbio. They are case sensitive and don't forget
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
#' \code{reference_month}, \code{mean}, \code{median}, \code{sd}, \code{coefvar},
#' \code{min}, \code{max}, \code{respondents}, \code{base}.
#'
#' @examples
#' \dontrun {
#' indic <- c("IPCA", "IPC-Fipe")
#' end_date <- "2018-01-31"
#' x <- get_monthly_market_expectations(indic, end_date = end_date, `$top` = 10)
#' }
#' @export
get_monthly_market_expectations <- function(indic = NULL, start_date = NULL,
                                            end_date = NULL, ...) {

  url <- .build_expectations_url(
    "https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/odata/ExpectativaMercadoMensais",
    indic, start_date, end_date, ...)
  text_ <- .get_series(url)
  data_ <- jsonlite::fromJSON(text_)

  df_ <- tibble::as_tibble(data_$value)
  names(df_) <- sapply(names(df_), change_names, USE.NAMES = FALSE)

  df_$date <- as.Date(df_$date)
  refdate <- as.Date(paste0("01", df_$reference_date), "%d%m/%Y")
  levels_ <- format(sort(unique(refdate)), "%Y-%m")
  x_ <- format(refdate, "%Y-%m")
  df_$reference_date <- factor(x_, levels = levels_, ordered = TRUE)

  df_
}

.build_expectations_url <- function(url, indic, start_date, end_date, ...) {
  if (is.null(indic)) {
    indic_filter <- NULL
  } else {
    indic_filter <- paste(sprintf("Indicador eq '%s'", indic), collapse = " or ")
    indic_filter <- paste0("(", indic_filter, ")")
  }

  sd_filter <- if (!is.null(start_date))
    sprintf("Data ge '%s'", start_date) else NULL

  ed_filter <- if (!is.null(end_date))
    sprintf("Data le '%s'", end_date) else NULL

  filter__ <- paste(c(indic_filter, sd_filter, ed_filter), collapse = " and ")
  if (filter__ == "")
    filter__ <- NULL

  httr::modify_url(
    url,
    query = list(
      `$filter` = filter__,
      `$format` = "application/json",
      `$orderby` = "Data desc",
      ...)
  )
}

change_names <- function(name) switch(
  name,
  "Indicador" = "indic",
  "Data" = "date",
  "DataReferencia" = "reference_date",
  "Media" = "mean",
  "Mediana" = "median",
  "DesvioPadrao" = "sd",
  "Minimo" = "min",
  "Maximo" = "max",
  "numeroRespondentes" = "respondents",
  "CoeficienteVariacao" = "coefvar",
  "baseCalculo" = "base",
  "IndicadorDetalhe" = "indic_detail",
  "Suavizada" = "smoothed",
  "tipoCalculo" = "typeCalc",
  name
)

#' Get quarterly market expectations of economic indicators
#'
#' Statistics for the quarterly expectations of economic indicators: mean, median, standard
#' deviate, minimum, maximum and the coefficient of variation.
#' All statistics are computed based on quarterly expectations provided by many financial
#' institutions in Brazil: banks, funds, risk managers, so on and so forth.
#' These expections and its statistics are used to build the FOCUS Report weekly
#' released by the Brazilian Central Bank.
#'
#' There are quarterly expectations available for the following indicators: PIB Agropecuária,
#' PIB Industrial, PIB Serviços, PIB Total.
#'
#' @param indic a character vector with economic indicators names: PIB Agropecuária,
#' PIB Industrial, PIB Serviços, PIB Total. They are case sensitive and don't forget
#' the accents.
#' @param start_date series initial date. Accepts ISO character formated date and \code{Date}.
#' @param end_date series final date. Accepts ISO character formated date and \code{Date}.
#' @param ... additional parameters to be passed to the API
#'
#' \code{indic} argumento must be one of these: PIB Agropecuária,
#' PIB Industrial, PIB Serviços, PIB Total. Respecting the case, blank spaces and
#' accents.
#'
#' The \code{...} is to be used with API's parameters. \code{$top} to specify
#' the maximum number of rows to be returned, this returns the \code{$top} rows,
#' in chronological order. There is also \code{$skip} to ignore the first rows.
#'
#' @return
#' A \code{data.frame} with the following nine columns: \code{date}, \code{indic},
#' \code{reference_quarter}, \code{mean}, \code{median}, \code{sd}, \code{coefvar},
#' \code{min}, \code{max}, \code{respondents}.
#'
#' @examples
#' indic <- c("PIB Industrial", "PIB Total")
#' end_date <- "2018-01-31"
#' x <- get_quarterly_market_expectations(indic, end_date = end_date, `$top` = 10)
#'
#' @export
get_quarterly_market_expectations <- function(indic = NULL, start_date = NULL,
                                              end_date = NULL, ...) {

  url <- .build_expectations_url(
    "https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/odata/ExpectativasMercadoTrimestrais",
    indic, start_date, end_date, ...)

  text_ <- .get_series(url)
  data_ <- jsonlite::fromJSON(text_)

  df_ <- tibble::as_tibble(data_$value)
  names(df_) <- sapply(names(df_), change_names, USE.NAMES = FALSE)

  df_$date <- as.Date(df_$date)
  df_
}


#' Get annual market expectations of economic indicators
#'
#' Statistics for the annual expectations of economic indicators: mean, median, standard
#' deviate, minimum, maximum and the coefficient of variation.
#' All statistics are computed based on annual expectations provided by many financial
#' institutions in Brazil: banks, funds, risk managers, so on and so forth.
#' These expections and its statistics are used to build the FOCUS Report weekly
#' released by the Brazilian Central Bank.
#'
#' There are annual expectations available for the following indicators: Balança Comercial,
#' Balanço de Pagamentos, Fiscal, IGP-DI, IGP-M, INPC, IPA-DI, IPA-M, IPCA, IPCA-15, IPC-Fipe,
#' Preços administrados por contrato e monitorados, Produção industrial, PIB Agropecuária,
#' PIB Industrial, PIB Serviços, PIB Total, Meta para taxa over-selic, Taxa de câmbio.
#'
#' @param indic a character vector with economic indicators names: Balança Comercial,
#' Balanço de Pagamentos, Fiscal, IGP-DI, IGP-M, INPC, IPA-DI, IPA-M, IPCA, IPCA-15, IPC-Fipe,
#' Preços administrados por contrato e monitorados, Produção industrial, PIB Agropecuária,
#' PIB Industrial, PIB Serviços, PIB Total, Meta para taxa over-selic, Taxa de câmbio.
#' They are case sensitive and don't forget the accents.
#' @param start_date series initial date. Accepts ISO character formated date and \code{Date}.
#' @param end_date series final date. Accepts ISO character formated date and \code{Date}.
#' @param ... additional parameters to be passed to the API
#'
#' \code{indic} argumento must be one of these: Balança Comercial,
#' Balanço de Pagamentos, Fiscal, IGP-DI, IGP-M, INPC, IPA-DI, IPA-M, IPCA, IPCA-15, IPC-Fipe,
#' Preços administrados por contrato e monitorados, Produção industrial, PIB Agropecuária,
#' PIB Industrial, PIB Serviços, PIB Total, Meta para taxa over-selic, Taxa de câmbio.
#' Respecting the case, blank spaces and accents.
#'
#' The \code{...} is to be used with API's parameters. \code{$top} to specify
#' the maximum number of rows to be returned, this returns the \code{$top} rows,
#' in chronological order. There is also \code{$skip} to ignore the first rows.
#'
#' @return
#' A \code{data.frame} with the following ten columns: \code{date}, \code{indic},
#' \code{indic_detail}, \code{reference_year}, \code{mean}, \code{median}, \code{sd},
#' \code{coefvar}, \code{min}, \code{max}, \code{respondents}, \code{base}.
#'
#' @examples
#' indic <- c("PIB Total", "Fiscal")
#' end_date <- "2018-01-31"
#' x <- get_annual_market_expectations(indic, end_date = end_date, `$top` = 10)
#'
#' @export
get_annual_market_expectations <- function(indic = NULL, start_date = NULL,
                                           end_date = NULL, ...) {

  url <- .build_expectations_url(
    "https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/odata/ExpectativasMercadoAnuais",
    indic, start_date, end_date, ...)

  text_ <- .get_series(url)
  data_ <- jsonlite::fromJSON(text_)

  df_ <- tibble::as_tibble(data_$value)
  names(df_) <- sapply(names(df_), change_names, USE.NAMES = FALSE)
  df_$date <- as.Date(df_$date)
  df_
}


#' Get inflation's market expectations for the next 12 months
#'
#' Statistics of inflation's market expectations for the next 12 months:
#' mean, median, standard
#' deviate, minimum, maximum and the coefficient of variation.
#' All statistics are computed based on expectations provided by many financial
#' institutions in Brazil: banks, funds, risk managers, so on and so forth.
#' These expections and its statistics are used to build the FOCUS Report weekly
#' released by the Brazilian Central Bank.
#'
#' There are inflation's expectations available for the following indicators:
#' IGP-DI, IGP-M, INPC, IPA-DI, IPA-M, IPCA, IPCA-15, IPC-Fipe.
#'
#' @param indic a character vector with economic indicators names:
#' IGP-DI, IGP-M, INPC, IPA-DI, IPA-M, IPCA, IPCA-15, IPC-Fipe.
#' @param start_date series initial date.
#' Accepts ISO character formated date and \code{Date}.
#' @param end_date series final date.
#' Accepts ISO character formated date and \code{Date}.
#' @param ... additional parameters to be passed to the API
#'
#' \code{indic} argumento must be one of these:
#' IGP-DI, IGP-M, INPC, IPA-DI, IPA-M, IPCA, IPCA-15, IPC-Fipe.
#' Respecting the case, blank spaces and accents.
#'
#' The \code{...} is to be used with API's parameters. \code{$top} to specify
#' the maximum number of rows to be returned, this returns the \code{$top} rows,
#' in chronological order. There is also \code{$skip} to ignore the first rows.
#'
#' @return
#' A \code{data.frame} with the following ten columns: \code{date}, \code{indic},
#' \code{smoothed}, \code{mean}, \code{median}, \code{sd},
#' \code{coefvar}, \code{min}, \code{max}, \code{respondents}, \code{base}.
#'
#' @examples
#' indic <- c("IPCA", "IGP-M")
#' end_date <- "2018-06-22"
#' x <- get_twelve_months_inflation_expectations(indic, end_date = end_date, `$top` = 10)
#'
#' @export
get_twelve_months_inflation_expectations <- function(indic = NULL, start_date = NULL,
                                                 end_date = NULL, ...) {

  url <- .build_expectations_url(
    "https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/odata/ExpectativasMercadoInflacao12Meses",
    indic, start_date, end_date, ...)

  text_ <- .get_series(url)
  data_ <- jsonlite::fromJSON(text_)

  df_ <- tibble::as_tibble(data_$value)
  names(df_) <- sapply(names(df_), change_names, USE.NAMES = FALSE)
  df_$date <- as.Date(df_$date)
  df_
}


#' Get monthly market expectations from top 5 providers
#'
#' Statistics of top 5's monthly market expectations:
#' mean, median, standard
#' deviate, minimum, maximum and the coefficient of variation.
#' All statistics are computed based on expectations provided by many financial
#' institutions in Brazil: banks, funds, risk managers, so on and so forth.
#' These expections and its statistics are used to build the FOCUS Report weekly
#' released by the Brazilian Central Bank.
#'
#' There are inflation's expectations available for the following indicators:
#' IGP-DI, IGP-M, IPCA, Meta para taxa over-selic, Taxa de câmbio
#'
#' @param indic a character vector with economic indicators names:
#' IGP-DI, IGP-M, IPCA, Meta para taxa over-selic, Taxa de câmbio.
#' @param start_date series initial date.
#' Accepts ISO character formated date and \code{Date}.
#' @param end_date series final date.
#' Accepts ISO character formated date and \code{Date}.
#' @param ... additional parameters to be passed to the API
#'
#' \code{indic} argumento must be one of these:
#' IGP-DI, IGP-M, IPCA, Meta para taxa over-selic, Taxa de câmbio.
#' Respecting the case, blank spaces and accents.
#'
#' The \code{...} is to be used with API's parameters. \code{$top} to specify
#' the maximum number of rows to be returned, this returns the \code{$top} rows,
#' in chronological order. There is also \code{$skip} to ignore the first rows.
#'
#' @return
#' A \code{data.frame} with the following nine columns: \code{date}, \code{indic},
#' \code{reference_month}, \code{type}, \code{mean}, \code{median}, \code{sd},
#' \code{coefvar},
#' \code{min}, \code{max}.
#'
#' @examples
#' indic <- "IPCA"
#' end_date <- "2018-06-22"
#' x <- get_top5s_monthly_market_expectations(indic, end_date = end_date, `$top` = 10)
#'
#' @export
get_top5s_monthly_market_expectations <- function(indic = NULL, start_date = NULL,
                                                 end_date = NULL, ...) {

  url <- .build_expectations_url(
    "https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/odata/ExpectativasMercadoTop5Mensais",
    indic, start_date, end_date, ...)

  text_ <- .get_series(url)
  data_ <- jsonlite::fromJSON(text_)

  df_ <- tibble::as_tibble(data_$value)
  names(df_) <- sapply(names(df_), change_names, USE.NAMES = FALSE)
  df_$date <- as.Date(df_$date)
  df_
}


#' Get annual market expectations from top 5 providers
#'
#' Statistics of top 5's annual market expectations:
#' mean, median, standard
#' deviate, minimum, maximum and the coefficient of variation.
#' All statistics are computed based on expectations provided by many financial
#' institutions in Brazil: banks, funds, risk managers, so on and so forth.
#' These expections and its statistics are used to build the FOCUS Report weekly
#' released by the Brazilian Central Bank.
#'
#' There are inflation's expectations available for the following indicators:
#' IGP-DI, IGP-M, IPCA, Meta para taxa over-selic, Taxa de câmbio
#'
#' @param indic a character vector with economic indicators names:
#' IGP-DI, IGP-M, IPCA, Meta para taxa over-selic, Taxa de câmbio.
#' @param start_date series initial date.
#' Accepts ISO character formated date and \code{Date}.
#' @param end_date series final date.
#' Accepts ISO character formated date and \code{Date}.
#' @param ... additional parameters to be passed to the API
#'
#' \code{indic} argumento must be one of these:
#' IGP-DI, IGP-M, IPCA, Meta para taxa over-selic, Taxa de câmbio.
#' Respecting the case, blank spaces and accents.
#'
#' The \code{...} is to be used with API's parameters. \code{$top} to specify
#' the maximum number of rows to be returned, this returns the \code{$top} rows,
#' in chronological order. There is also \code{$skip} to ignore the first rows.
#'
#' @return
#' A \code{data.frame} with the following nine columns: \code{date}, \code{indic},
#' \code{indic_detail},
#' \code{reference_year}, \code{type}, \code{mean}, \code{median},
#' \code{sd},
#' \code{coefvar},
#' \code{min}, \code{max}.
#'
#' @examples
#' indic <- "IPCA"
#' end_date <- "2018-06-22"
#' x <- get_top5s_annual_market_expectations(indic, end_date = end_date, `$top` = 10)
#'
#' @export
get_top5s_annual_market_expectations <- function(indic = NULL, start_date = NULL,
                                                end_date = NULL, ...) {

  url <- .build_expectations_url(
    "https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/odata/ExpectativasMercadoTop5Anuais",
    indic, start_date, end_date, ...)

  text_ <- .get_series(url)
  data_ <- jsonlite::fromJSON(text_)

  df_ <- tibble::as_tibble(data_$value)
  names(df_) <- sapply(names(df_), change_names, USE.NAMES = FALSE)
  df_$date <- as.Date(df_$date)
  df_
}


.get_market_expectations_url <- function(x) {
  switch(
    x,
    "annual" = "https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/odata/ExpectativasMercadoAnuais",
    "quarterly" = "https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/odata/ExpectativasMercadoTrimestrais",
    "monthly" = "https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/odata/ExpectativaMercadoMensais",
    "inflation-12-months" = "https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/odata/ExpectativasMercadoInflacao12Meses",
    "top5s-monthly" = "https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/odata/ExpectativasMercadoTop5Mensais",
    "top5s-annual" = "https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/odata/ExpectativasMercadoTop5Anuais",
  )
}


#' @export
get_market_expectations <- function(type = c("annual",
                                             "quarterly",
                                             "monthly",
                                             "inflation-12-months",
                                             "top5s-monthly",
                                             "top5s-annual"),
                                    indic = NULL, start_date = NULL,
                                    end_date = NULL, keep_names = TRUE, ...) {
  type <- match.arg(type)
  url <- .build_expectations_url(.get_market_expectations_url(type),
                           indic, start_date, end_date, ...)

  text_ <- .get_series(url)
  data_ <- jsonlite::fromJSON(text_)
  df_ <- tibble::as_tibble(data_$value)
  if (!keep_names) {
    names(df_) <- sapply(names(df_), change_names, USE.NAMES = FALSE)
    df_$date <- as.Date(df_$date)
  } else {
    df_$Data <- as.Date(df_$Data)
  }

  df_
}
