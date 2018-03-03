
series_info_url = function(x) {
  url = "https://www3.bcb.gov.br/sgspub/consultarvalores/consultarValoresSeries.do?method=consultarGraficoPorId"
  httr::modify_url(url, query = list(hdOidSeriesSelecionadas = x$code))
}

series_info = function(x) {
  url = series_info_url(x)
  res = httr::GET(url)
  cnt = httr::content(res, as = "text")

  doc = xml2::read_html(cnt)
  info = xml2::xml_find_first(doc, '//tr[@class="fundoPadraoAClaro3"]')
  info = xml2::xml_find_all(info, ".//td")
  info = xml2::xml_text(info)
  info = as.list(info[-length(info)])
  info = setNames(info, c("code", "description", "unit", "frequency", "start_date", "last_date"))

  if (as.numeric(info$code) != x$code)
    stop("Downloaded info is different from series info")

  info$code = NULL
  info$url = url
  info$start_date = as.Date(info$start_date, "%d/%m/%Y")
  info$last_date = as.Date(info$last_date, "%d/%m/%Y")

  info
}

