
search_datasets <- function(q = "", offset = 0, all_fields = 1) {
  url <- parse_url("https://dadosabertos.bcb.gov.br/api/search/dataset")
  url$query <- list(q = q, offset = offset, all_fields = all_fields)
  f <- http_download("get", url)
  data <- fromJSON(f, simplifyVector = TRUE, simplifyDataFrame = FALSE)
  results <- map_dfr(data$results, function(res) {
    res1 <- fromJSON(res$data_dict,
      simplifyVector = TRUE,
      simplifyDataFrame = FALSE
    )

    res1_extras <- lapply(res1$extras, function(x) x$value)
    res1_extras <- setNames(res1_extras, lapply(res1$extras, function(x) x$key))

    tibble(
      title = res1$title,
      name = res1$id,
      organization = res1$organization$title,
      frequency = res1_extras$periodicidade,
      units = res1_extras$unidade_medida,
      cod_sgs = res1_extras$codigo_sgs,
      from = res1_extras$inicio_periodo,
      to = res1_extras$fim_periodo
    )
  })
  list(
    count = data$count,
    data = data,
    results = results
  )
}

dataset_info <- function(id) {
  url <- parse_url("https://dadosabertos.bcb.gov.br/api/rest/dataset/")
  url$path <- c(url$path, id)
  url <- httr::build_url(url)
  f <- http_download("get", url)
  fromJSON(f, simplifyVector = TRUE, simplifyDataFrame = FALSE)
}