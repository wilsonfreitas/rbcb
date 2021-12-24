
#' Get monthly market expectations of economic indicators
#'
#' Statistics for the monthly expectations of economic indicators.
#' All statistics are computed based on monthly expectations provided by many financial
#' institutions in Brazil: banks, funds, risk managers, so on and so forth.
#' These expections and its statistics are used to build the FOCUS Report weekly
#' released by the Brazilian Central Bank.
#'
#' There are monthly expectations available for the following indicators:
#'
#' \itemize{
#' \item Câmbio
#' \item IGP-DI
#' \item IGP-M
#' \item INPC
#' \item IPA-DI
#' \item IPA-M
#' \item IPCA
#' \item IPCA Administrados
#' \item IPCA Alimentação no domicílio
#' \item IPCA Bens industrializados
#' \item IPCA Livres
#' \item IPCA Serviços
#' \item IPCA-15
#' \item IPC-Fipe
#' \item Produção industrial
#' \item Selic
#' \item Taxa de desocupação
#' }
#'
#' Check <https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/documentacao#ExpectativaMercadoMensais>
#' for more details
#'
#' @param indic a character vector with economic indicators names.
#' They are case sensitive and don't forget the accents.
#' @param start_date series initial date. Accepts ISO character formated date and \code{Date}.
#' @param end_date series final date. Accepts ISO character formated date and \code{Date}.
#' @param ... additional parameters to be passed to the API
#'
#' \code{indic} argument must be one of indicators listed in Details.
#' Respecting the case, blank spaces and accents.
#'
#' The \code{...} is to be used with API's parameters. \code{$top} to specify
#' the maximum number of rows to be returned, this returns the \code{$top} rows,
#' in chronological order. There is also \code{$skip} to ignore the first rows.
#'
#' @return
#' A \code{data.frame} with the requested data.
#'
#' @examples
#' \dontrun{
#' indic <- c("IPCA", "IPC-Fipe")
#' end_date <- "2018-01-31"
#' x <- get_monthly_market_expectations(indic, end_date = end_date, `$top` = 10)
#'
#' # return all indicators for the specified date range
#' start_date <- "2021-01-01"
#' x <- get_monthly_market_expectations(start_date = start_date, `$top` = 20)
#' }
#' @export
get_monthly_market_expectations <- function(indic = NULL, start_date = NULL,
                                            end_date = NULL, ...) {

  df_ <- get_market_expectations("monthly", indic, start_date, end_date,
                                 keep_names = FALSE, ...)

  refdate <- as.Date(paste0("01", df_$reference_date), "%d%m/%Y")
  levels_ <- format(sort(unique(refdate)), "%Y-%m")
  x_ <- format(refdate, "%Y-%m")
  df_$reference_date <- factor(x_, levels = levels_, ordered = TRUE)

  df_
}

#' Get quarterly market expectations of economic indicators
#'
#' Statistics for the quarterly expectations of economic indicators.
#' All statistics are computed based on quarterly expectations provided by many financial
#' institutions in Brazil: banks, funds, risk managers, so on and so forth.
#' These expections and its statistics are used to build the FOCUS Report weekly
#' released by the Brazilian Central Bank.
#'
#' There are quarterly expectations available for the following indicators:
#'
#' \itemize{
#' \item Câmbio
#' \item IPCA
#' \item IPCA Administrados
#' \item IPCA Alimentação no domicílio
#' \item IPCA Bens industrializados
#' \item IPCA Livres
#' \item IPCA Serviços
#' \item PIB Agropecuária
#' \item PIB Indústria
#' \item PIB Serviços
#' \item PIB Total
#' \item Taxa de desocupação
#' }
#'
#' Check <https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/documentacao#ExpectativasMercadoTrimestrais>
#' for more details
#'
#' @param indic a character vector with economic indicators names.
#' They are case sensitive and don't forget the accents.
#' @param start_date series initial date. Accepts ISO character formated date and \code{Date}.
#' @param end_date series final date. Accepts ISO character formated date and \code{Date}.
#' @param ... additional parameters to be passed to the API
#'
#' \code{indic} argument must be one of indicators listed in Details.
#' Respecting the case, blank spaces and accents.
#'
#' The \code{...} is to be used with API's parameters. \code{$top} to specify
#' the maximum number of rows to be returned, this returns the \code{$top} rows,
#' in chronological order. There is also \code{$skip} to ignore the first rows.
#'
#' @return
#' A \code{data.frame} with the requested data.
#'
#' @examples
#' \dontrun{
#' indic <- c("PIB Industrial", "PIB Total")
#' end_date <- "2018-01-31"
#' x <- get_quarterly_market_expectations(indic, end_date = end_date, `$top` = 10)
#'
#' # return all indicators for the specified date range
#' start_date <- "2021-01-01"
#' x <- get_quarterly_market_expectations(start_date = start_date, `$top` = 20)
#' }
#'
#' @export
get_quarterly_market_expectations <- function(indic = NULL, start_date = NULL,
                                              end_date = NULL, ...) {

  get_market_expectations("quarterly", indic, start_date, end_date,
                          keep_names = FALSE, ...)
}


#' Get annual market expectations of economic indicators
#'
#' Statistics for the annual expectations of economic indicators.
#' All statistics are computed based on annual expectations provided by many financial
#' institutions in Brazil: banks, funds, risk managers, so on and so forth.
#' These expections and its statistics are used to build the FOCUS Report weekly
#' released by the Brazilian Central Bank.
#'
#' There are annual expectations available for the following indicators:
#'
#' \itemize{
#' \item Balança Comercial
#' \item Câmbio
#' \item Conta corrente
#' \item Dívida bruta do governo geral
#' \item Dívida líquida do setor público
#' \item IGP-DI
#' \item IGP-M
#' \item INPC
#' \item Investimento direto no país
#' \item IPA-DI
#' \item IPA-M
#' \item IPCA
#' \item IPCA Administrados
#' \item IPCA Alimentação no domicílio
#' \item IPCA Bens industrializados
#' \item IPCA Livres
#' \item IPCA Serviços
#' \item IPCA-15
#' \item IPC-FIPE
#' \item PIB Agropecuária
#' \item PIB Despesa de consumo da administração pública
#' \item PIB despesa de consumo das famílias
#' \item PIB Exportação de bens e serviços
#' \item PIB Formação Bruta de Capital Fixo
#' \item PIB Importação de bens e serviços
#' \item PIB Indústria
#' \item PIB Serviços
#' \item PIB Total
#' \item Produção industrial
#' \item Resultado nominal
#' \item Resultado primário
#' \item Selic
#' \item Taxa de desocupação
#' }
#'
#' Check <https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/documentacao#ExpectativasMercadoAnuais>
#' for more details
#'
#' @param indic a character vector with economic indicators names.
#' They are case sensitive and don't forget the accents.
#' @param start_date series initial date. Accepts ISO character formated date and \code{Date}.
#' @param end_date series final date. Accepts ISO character formated date and \code{Date}.
#' @param ... additional parameters to be passed to the API
#'
#' \code{indic} argument must be one of indicators listed in Details.
#' Respecting the case, blank spaces and accents.
#'
#' The \code{...} is to be used with API's parameters. \code{$top} to specify
#' the maximum number of rows to be returned, this returns the \code{$top} rows,
#' in chronological order. There is also \code{$skip} to ignore the first rows.
#'
#' @return
#' A \code{data.frame} with the requested data.
#'
#' @examples
#' \dontrun{
#' indic <- c("PIB Total", "Fiscal")
#' end_date <- "2018-01-31"
#' x <- get_annual_market_expectations(indic, end_date = end_date, `$top` = 10)
#'
#' # return all indicators for the specified date range
#' start_date <- "2021-01-01"
#' x <- get_annual_market_expectations(start_date = start_date, `$top` = 20)
#' }
#'
#' @export
get_annual_market_expectations <- function(indic = NULL, start_date = NULL,
                                           end_date = NULL, ...) {

  get_market_expectations("annual", indic, start_date, end_date,
                          keep_names = FALSE, ...)
}


#' Get inflation's market expectations for the next 12 months
#'
#' Statistics of inflation's market expectations for the next 12 months.
#' All statistics are computed based on expectations provided by many financial
#' institutions in Brazil: banks, funds, risk managers, so on and so forth.
#' These expections and its statistics are used to build the FOCUS Report weekly
#' released by the Brazilian Central Bank.
#'
#' There are inflation's expectations available for the following indicators:
#'
#' \itemize{
#' \item IGP-DI
#' \item IGP-M
#' \item INPC
#' \item IPA-DI
#' \item IPA-M
#' \item IPCA
#' \item IPCA Administrados
#' \item IPCA Alimentação no domicílio
#' \item IPCA Bens industrializados
#' \item IPCA Livres
#' \item IPCA Serviços
#' \item IPCA-15
#' \item IPC-FIPE
#' }
#'
#' Check <https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/documentacao#ExpectativasMercadoInflacao12Meses>
#' for more details
#'
#' @param indic a character vector with economic indicators names.
#' They are case sensitive and don't forget the accents.
#' @param start_date series initial date.
#' Accepts ISO character formated date and \code{Date}.
#' @param end_date series final date.
#' Accepts ISO character formated date and \code{Date}.
#' @param ... additional parameters to be passed to the API
#'
#' \code{indic} argument must be one of indicators listed in Details.
#' Respecting the case, blank spaces and accents.
#'
#' The \code{...} is to be used with API's parameters. \code{$top} to specify
#' the maximum number of rows to be returned, this returns the \code{$top} rows,
#' in chronological order. There is also \code{$skip} to ignore the first rows.
#'
#' @return
#' A \code{data.frame} with the requested data.
#'
#' @examples
#' \dontrun{
#' indic <- c("IPCA", "IGP-M")
#' end_date <- "2018-06-22"
#' x <- get_twelve_months_inflation_expectations(indic, end_date = end_date, `$top` = 10)
#'
#' # return all indicators for the specified date range
#' start_date <- "2021-01-01"
#' x <- get_twelve_months_inflation_expectations(start_date = start_date, `$top` = 20)
#' }
#'
#' @export
get_twelve_months_inflation_expectations <- function(indic = NULL, start_date = NULL,
                                                 end_date = NULL, ...) {

  get_market_expectations("inflation-12-months", indic, start_date, end_date,
                          keep_names = FALSE, ...)
}


#' Get monthly market expectations from top 5 providers
#'
#' Statistics of monthly expectations for top 5 indicators.
#' All statistics are computed based on expectations provided by many financial
#' institutions in Brazil: banks, funds, risk managers, so on and so forth.
#' These expections and its statistics are used to build the FOCUS Report weekly
#' released by the Brazilian Central Bank.
#'
#' There are inflation's expectations available for the following indicators:
#'
#' \itemize{
#' \item Câmbio
#' \item IGP-DI
#' \item IGP-M
#' \item IPCA
#' \item Selic
#' }
#'
#' Check <https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/documentacao#ExpectativasMercadoTop5Mensais>
#' for more details
#'
#' @param indic a character vector with economic indicators names.
#' They are case sensitive and don't forget the accents.
#' @param start_date series initial date.
#' Accepts ISO character formated date and \code{Date}.
#' @param end_date series final date.
#' Accepts ISO character formated date and \code{Date}.
#' @param ... additional parameters to be passed to the API
#'
#' \code{indic} argument must be one of indicators listed in Details.
#' Respecting the case, blank spaces and accents.
#'
#' The \code{...} is to be used with API's parameters. \code{$top} to specify
#' the maximum number of rows to be returned, this returns the \code{$top} rows,
#' in chronological order. There is also \code{$skip} to ignore the first rows.
#'
#' @return
#' A \code{data.frame} with the requested data.
#'
#' @examples
#' \dontrun{
#' indic <- "IPCA"
#' end_date <- "2018-06-22"
#' x <- get_top5s_monthly_market_expectations(indic, end_date = end_date, `$top` = 10)
#'
#' # return all indicators for the specified date range
#' start_date <- "2021-01-01"
#' x <- get_top5s_monthly_market_expectations(start_date = start_date, `$top` = 20)
#' }
#'
#' @export
get_top5s_monthly_market_expectations <- function(indic = NULL, start_date = NULL,
                                                 end_date = NULL, ...) {

  get_market_expectations("top5s-monthly", indic, start_date, end_date,
                          keep_names = FALSE, ...)
}


#' Get annual market expectations from top 5 providers
#'
#' Statistics of annual expectations for top 5 indicators.
#' All statistics are computed based on expectations provided by many financial
#' institutions in Brazil: banks, funds, risk managers, so on and so forth.
#' These expections and its statistics are used to build the FOCUS Report weekly
#' released by the Brazilian Central Bank.
#'
#' There are inflation's expectations available for the following indicators:
#'
#' \itemize{
#' \item Câmbio
#' \item IGP-DI
#' \item IGP-M
#' \item IPCA
#' \item Selic
#' }
#'
#' Check <https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/documentacao#ExpectativasMercadoTop5Anuais>
#' for more details
#'
#' @param indic a character vector with economic indicators names.
#' They are case sensitive and don't forget the accents.
#' @param start_date series initial date.
#' Accepts ISO character formated date and \code{Date}.
#' @param end_date series final date.
#' Accepts ISO character formated date and \code{Date}.
#' @param ... additional parameters to be passed to the API
#'
#' \code{indic} argument must be one of indicators listed in Details.
#' Respecting the case, blank spaces and accents.
#'
#' The \code{...} is to be used with API's parameters. \code{$top} to specify
#' the maximum number of rows to be returned, this returns the \code{$top} rows,
#' in chronological order. There is also \code{$skip} to ignore the first rows.
#'
#' @return
#' A \code{data.frame} with the requested data.
#'
#' @examples
#' \dontrun{
#' indic <- "IPCA"
#' end_date <- "2018-06-22"
#' x <- get_top5s_annual_market_expectations(indic, end_date = end_date, `$top` = 10)
#'
#' # return all indicators for the specified date range
#' start_date <- "2021-01-01"
#' x <- get_top5s_annual_market_expectations(start_date = start_date, `$top` = 20)
#' }
#'
#' @export
get_top5s_annual_market_expectations <- function(indic = NULL, start_date = NULL,
                                                 end_date = NULL, ...) {

  get_market_expectations("top5s-annual", indic, start_date, end_date,
                          keep_names = FALSE, ...)
}


#' Get market expectations sent by officially recognized Institutions that
#' contribute with expectations
#'
#' Statistics of market expectations sent by institutions.
#' All statistics are computed based on expectations provided by many financial
#' institutions in Brazil: banks, funds, risk managers, so on and so forth.
#' These expections and its statistics are used to build the FOCUS Report weekly
#' released by the Brazilian Central Bank.
#'
#' There are market expectations available for the following indicators:
#'
#' \itemize{
#' \item Balança Comercial
#' \item Câmbio
#' \item Conta corrente
#' \item Dívida bruta do governo geral
#' \item Dívida líquida do setor público
#' \item IGP-DI
#' \item IGP-M
#' \item INPC
#' \item Investimento direto no país
#' \item IPA-DI
#' \item IPA-M
#' \item IPCA
#' \item IPCA Administrados
#' \item IPCA Alimentação no domicílio
#' \item IPCA Bens industrializados
#' \item IPCA Livres
#' \item IPCA Serviços
#' \item IPCA-15
#' \item IPC-FIPE
#' \item PIB Agropecuária
#' \item PIB Despesa de consumo da administração pública
#' \item PIB despesa de consumo das famílias
#' \item PIB Exportação de bens e serviços
#' \item PIB Formação Bruta de Capital Fixo
#' \item PIB Importação de bens e serviços
#' \item PIB Indústria
#' \item PIB Serviços
#' \item PIB Total
#' \item Produção industrial
#' \item Resultado nominal
#' \item Resultado primário
#' \item Selic
#' \item Taxa de desocupação
#' }
#'
#' Check <https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/documentacao#ExpectativasMercadoInstituicoes>
#' for more details
#'
#' @param indic a character vector with economic indicators names.
#' They are case sensitive and don't forget the accents.
#' @param start_date series initial date.
#' Accepts ISO character formated date and \code{Date}.
#' @param end_date series final date.
#' Accepts ISO character formated date and \code{Date}.
#' @param ... additional parameters to be passed to the API
#'
#' \code{indic} argument must be one of indicators listed in Details.
#' Respecting the case, blank spaces and accents.
#'
#' The \code{...} is to be used with API's parameters. \code{$top} to specify
#' the maximum number of rows to be returned, this returns the \code{$top} rows,
#' in chronological order. There is also \code{$skip} to ignore the first rows.
#'
#' @return
#' A \code{data.frame} with the requested data.
#'
#' @examples
#' \dontrun{
#' indic <- "IPCA"
#' x <- get_institutions_market_expectations(indic, `$top` = 10)
#'
#' x <- get_institutions_market_expectations(`$top` = 20)
#' }
#'
#' @export
get_institutions_market_expectations <- function(indic = NULL, start_date = NULL,
                                                 end_date = NULL, ...) {

  get_market_expectations("institutions", indic, start_date, end_date,
                          keep_names = FALSE, ...)
}


#' Get market expectations
#'
#' General function to get statistics of market expectations.
#' The API provides requests for annual, monthly, and quarterly expectations.
#' Is is also proveided expectations for 12 months ahead, specific requests for
#' the top 5 indicators for annual and monthly expectations and data provided
#' by financial institutions.
#'
#' All statistics are computed based on expectations provided by many financial
#' institutions in Brazil: banks, funds, risk managers, so on and so forth.
#' These expections and its statistics are used to build the FOCUS Report weekly
#' released by the Brazilian Central Bank.
#'
#' There are market expectations available for the following indicators:
#'
#' \itemize{
#' \item Balança Comercial
#' \item Câmbio
#' \item Conta corrente
#' \item Dívida bruta do governo geral
#' \item Dívida líquida do setor público
#' \item IGP-DI
#' \item IGP-M
#' \item INPC
#' \item Investimento direto no país
#' \item IPA-DI
#' \item IPA-M
#' \item IPCA
#' \item IPCA Administrados
#' \item IPCA Alimentação no domicílio
#' \item IPCA Bens industrializados
#' \item IPCA Livres
#' \item IPCA Serviços
#' \item IPCA-15
#' \item IPC-FIPE
#' \item PIB Agropecuária
#' \item PIB Despesa de consumo da administração pública
#' \item PIB despesa de consumo das famílias
#' \item PIB Exportação de bens e serviços
#' \item PIB Formação Bruta de Capital Fixo
#' \item PIB Importação de bens e serviços
#' \item PIB Indústria
#' \item PIB Serviços
#' \item PIB Total
#' \item Produção industrial
#' \item Resultado nominal
#' \item Resultado primário
#' \item Selic
#' \item Taxa de desocupação
#' }
#'
#' Check <https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/documentacao>
#' for more details
#'
#' @param type a character with one of the following: \code{annual}, \code{quarterly}
#' \code{monthly}, \code{inflation-12-months}, \code{top5s-monthly}, \code{top5s-annual},
#' \code{institutions}.
#' @param indic a character vector with economic indicators names.
#' They are case sensitive and don't forget the accents.
#' @param start_date series initial date.
#' Accepts ISO character formated date and \code{Date}.
#' @param end_date series final date.
#' Accepts ISO character formated date and \code{Date}.
#' @param keep_names if \code{TRUE} keeps the column names returned by the API
#' (in portuguese), if \code{FALSE} the columns are renamed to standardized
#' names (in english).
#' @param ... additional parameters to be passed to the API
#'
#' \code{type} defines the API used to fetch data.
#'
#' \itemize{
#' \item \code{annual}: refers to the API *Expectativas de Mercado Anuais* for annual market expectations
#' \item \code{quarterly}: refers to the API *Expectativas de Mercado Trimestrais* for quarterly market expectations
#' \item \code{monthly}: refers to the API *Expectativas de Mercado Mensais* for monthly market expectations
#' \item \code{inflation-12-months}: refers to the API *Expectativas de mercado para inflação nos próximos 12 meses* for market expectations of inflation indexes for the next 12 months.
#' \item \code{top5s-monthly}: refers to the API *Expectativas de mercado mensais para os indicadores do Top 5* for monthly market expectations of top 5 indicators
#' \item \code{top5s-annual}: refers to the API *Expectativas de mercado anuais para os indicadores do Top 5* for annual market expectations of top 5 indicators
#' \item \code{institutions}: refers to the API *Expectativas de mercado informadas pelas instituições credenciadas* for market expectations sent by institutions
#' }
#'
#' \code{indic} argument must be one of indicators listed in Details.
#' Respecting the case, blank spaces and accents.
#'
#' The \code{...} is to be used with API's parameters. \code{$top} to specify
#' the maximum number of rows to be returned, this returns the \code{$top} rows,
#' in chronological order.
#' \code{$skip} can be used to ignore the first rows.
#' If provided \code{$filter} applies filters according to <https://olinda.bcb.gov.br/olinda/servico/ajuda>.
#'
#' @return
#' A \code{data.frame} with the requested data.
#'
#' @examples
#' \dontrun{
#' indic <- c("IPCA", "Câmbio")
#' x <- get_market_expectations("annual", indic, `$top` = 10)
#'
#' x <- get_market_expectations("monthly", "Selic", `$top` = 20)
#'
#' # get monthly expectations for top 5 indicators since 2021
#' x <- get_market_expectations("top5s-monthly", start_date = "2021-01-01")
#'
#' # get annual expectations for top 5 indicators since 2021
#' x <- get_market_expectations("top5s-annual", `$top` = 20)
#'
#' # get all inflation expectations for 12 months ahead starting on 2021-01
#' x <- get_market_expectations("inflation-12-months", start_date = "2021-01-01")
#'
#' # get all IPCA expectations informed by financial institutions since 2020
#' x <- get_market_expectations("institutions", "IPCA", start_date = "2020-01-01")
#' }
#'
#' @export
get_market_expectations <- function(type = c("annual",
                                             "quarterly",
                                             "monthly",
                                             "inflation-12-months",
                                             "top5s-monthly",
                                             "top5s-annual",
                                             "institutions"),
                                    indic = NULL, start_date = NULL,
                                    end_date = NULL, keep_names = TRUE, ...) {
  type <- match.arg(type)
  url <- .build_expectations_url(.get_market_expectations_url(type),
                           indic, start_date, end_date, ...)

  text_ <- .get_series(url)
  data_ <- jsonlite::fromJSON(text_)

  if (!is.null(data_$value) && length(data_$value) == 0)
    return(tibble::tibble())
  if (is.null(data_$value))
    stop("BCB API Request error: no value attribute returned")

  df_ <- tibble::as_tibble(data_$value)
  df_$Data <- as.Date(df_$Data)

  if (!keep_names) {
    names(df_) <- sapply(names(df_), change_names, USE.NAMES = FALSE)
  }

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
    "institutions" = "https://olinda.bcb.gov.br/olinda/servico/Expectativas/versao/v1/odata/ExpectativasMercadoInstituicoes",
  )
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

  q <- list(...)
  q[["$format"]] <- "application/json"
  # q[["$orderby"]] <- "Data desc"
  filter__ <- paste(c(indic_filter, sd_filter, ed_filter, q[["$filter"]]),
                    collapse = " and ")
  filter__ <- if (filter__ == "") NULL else filter__
  q[["$filter"]] <- filter__

  httr::modify_url(url, query = q)
}

change_names <- function(name) switch(
  name,
  "Instituicao" = "institution",
  "Indicador" = "indic",
  "Periodicidade" = "periodicity",
  "Valor" = "value",
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

