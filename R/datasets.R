ckan_action <- function(action, query) {
  url <- modify_url(
    paste0("https://dadosabertos.bcb.gov.br/api/3/action/", action),
    query = query
  )
  f <- http_download("get", url)
  fromJSON(f, simplifyVector = TRUE, simplifyDataFrame = FALSE)$result
}

search_datasets <- function(q = "", offset = 0) {
  data <- ckan_action("package_search", list(q = q, start = offset, rows = 10))
  field <- function(x) if (is.null(x)) NA_character_ else x
  results <- map_dfr(data$results, function(res) {
    tibble(
      title = res$title,
      name = res$id,
      organization = field(res$organization$title),
      frequency = field(res$periodicidade),
      units = field(res$unidade_medida),
      cod_sgs = field(res$codigo_sgs),
      from = field(res$inicio_periodo),
      to = field(res$fim_periodo)
    )
  })
  list(
    count = data$count,
    data = data,
    results = results
  )
}

dataset_info <- function(id) {
  ckan_action("package_show", list(id = id))
}
