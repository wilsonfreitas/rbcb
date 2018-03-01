
series_info_url = function(code) {
  sprintf("https://www3.bcb.gov.br/sgspub/consultarvalores/consultarValoresSeries.do?method=consultarGraficoPorId&hdOidSeriesSelecionadas=%d", code)
}

series_info = function(code) {
  url = series_info_url(code)
  res = httr::GET(url)
  cnt = httr::content(res, as = "text")
  doc = xml2::read_html(cnt)
  info = xml2::xml_find_first(doc, '//tr[@class="fundoPadraoAClaro3"]')
  info = xml2::xml_find_all(info, ".//td")
  info = xml2::xml_text(info)
  info = info[-length(info)]
  setNames(info, c("code", "description", "unit", "frequency", "start_date", "last_date"))
}

