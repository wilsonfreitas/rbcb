
series_info_url <- function(x) {
  url <- "https://www3.bcb.gov.br/sgspub/consultarvalores/consultarValoresSeries.do?method=consultarGraficoPorId"
  httr::modify_url(url, query = list(hdOidSeriesSelecionadas = x$code))
}

series_info <- function(x) {
  url <- series_info_url(x)
  res <- httr::GET(url)
  if (httr::status_code(res) != 200) {
    msg <- sprintf(
      "BCB SGS Request error %s for code %s",
      httr::status_code(res),
      x$code
    )
    stop(msg)
  }
  cnt <- httr::content(res, as = "text")

  doc <- xml2::read_html(cnt)
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
  cn <- c("code", "description", "unit", "frequency", "start_date", "last_date")
  info <- setNames(info, cn)

  if (as.numeric(info$code) != x$code) {
    stop(
      "Downloaded info is different from series info - given code: ",
      x$code, " info code: ", info$code
    )
  }

  info$code <- NULL
  info$url <- url
  info$start_date <- as.Date(info$start_date, "%d/%m/%Y")
  info$last_date <- as.Date(info$last_date, "%d/%m/%Y")

  info
}