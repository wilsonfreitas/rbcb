if (!covr::in_covr()) {
  skip_on_cran()
  skip_if_offline()
}

test_that("it should create a sgs object", {
  code <- sgs(USD = 1)
  expect_s3_class(code, "sgs")
  expect_equal(code[["USD"]]$code, 1)
})

test_that("it should create a sgs object with unamed codes", {
  code <- sgs(1)
  expect_s3_class(code, "sgs")
  expect_equal(code[["1"]]$code, 1)
})

test_that("it should create a multiple sgs object", {
  code <- sgs(USD = 1, IPCA = 433)
  expect_s3_class(code, "sgs")
  expect_equal(length(code), 2)
  expect_equal(code[["USD"]]$code, 1)
  expect_equal(code[["IPCA"]]$code, 433)
})

test_that("it should fail to create a sgs object", {
  expect_error(sgs(0))
  expect_error(sgs(-1))
})

test_that("it should untidy dataframe", {
  x <- sgs(USD = 1, SELIC = 1178)
  df <- rbcb_get(x, from = Sys.Date() - 10)
  untidy_data <- sgs_untidy(x, df, as = "xts")
  expect_equal(length(untidy_data), length(x))
  expect_equal(sort(names(x)), sort(names(untidy_data)))
})
test_that("it should keep the end date of period series (TR, TBF)", {
  f <- tempfile(fileext = ".json")
  writeLines('[
    {"data":"01/03/2015","dataFim":"29/03/2015","valor":"0.0661"},
    {"data":"01/03/2015","dataFim":"01/04/2015","valor":"0.1296"},
    {"data":"02/03/2015","dataFim":"02/04/2015","valor":"0.1300"}
  ]', f)
  x <- sgs(TR = 226)
  df <- sgs_create_series(x$TR, f)
  expect_equal(names(df), c("date", "enddate", "value", "name"))
  expect_s3_class(df$enddate, "Date")
  expect_equal(df$enddate[2], as.Date("2015-04-01"))

  tb <- .sgs_convert_split(x$TR, df, "tibble")
  expect_equal(names(tb), c("date", "enddate", "TR"))
  expect_equal(names(.sgs_convert_split(x$TR, df, "data.frame")), c("date", "enddate", "TR"))
  expect_error(.sgs_convert_split(x$TR, df, "xts"), "share a start date")
  expect_error(.sgs_convert_split(x$TR, df, "ts"), "share a start date")
  expect_s3_class(.sgs_convert_split(x$TR, df[-1, ], "xts"), "xts")
})

test_that("it should not add enddate to series without periods", {
  f <- tempfile(fileext = ".json")
  writeLines('[{"data":"01/03/2015","valor":"1.5"}]', f)
  x <- sgs(USD = 1)
  df <- sgs_create_series(x$USD, f)
  expect_equal(names(df), c("date", "value", "name"))
  expect_equal(names(.sgs_convert_split(x$USD, df, "tibble")), c("date", "USD"))
})

test_that("it should join the JSON of 10-year windows into one array", {
  f1 <- tempfile(fileext = ".json")
  f2 <- tempfile(fileext = ".json")
  writeLines('[{"data":"01/01/2000","valor":"1"}]', f1)
  writeLines('[\n{"data":"01/01/2010","valor":"2"},\n{"data":"02/01/2010","valor":"3"}\n]', f2)
  local_mocked_bindings(sgs_download = function(...) c(f1, f2))
  txt <- sgs_json(sgs(USD = 1)$USD, NULL, NULL, 0)
  df <- jsonlite::fromJSON(txt)
  expect_equal(df$valor, c("1", "2", "3"))
})
