
# library(httr)
# library(shiny)
# library(miniUI)

#' rbcb Search
#'
#' @description `rbcb_search()` opens an [RStudio
#'   gadget](https://shiny.rstudio.com/articles/gadgets.html) and
#'   [addin](http://rstudio.github.io/rstudioaddins/) that allows you to query
#'   for specific terms and see a suitable rbcb command to fetch the
#'   desired data.
#'
#' @export
rbcb_search <- function(text = "") {
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("rbcb search"),
    miniUI::miniContentPanel(
      shiny::textInput("q", "Search:", text),
      shiny::numericInput("offset", "Offset:", value = 0, min = 0, step = 10),
      shiny::htmlOutput("page_count"),
      shiny::tags$hr(),
      shiny::tableOutput("results")
    )
  )

  server <- function(input, output, session) {
    page_count <- shiny::reactiveVal(0)

    query_result <- shiny::reactive({
      url <- parse_url("https://dadosabertos.bcb.gov.br/api/search/dataset")
      url$query <- list(q = input$q, offset = input$offset, all_fields = 1)
      res <- GET(url)
      data <- jsonlite::fromJSON(content(res, as = "text"))
      page_count(data$count)
      data$results
    })

    query_codes <- shiny::reactive({
      x <- query_result()
      sapply(x$res_name, function(.x) {
        ix <- which(grepl("json_serie-sgs-\\d+", .x))
        if (length(ix)) {
          as.numeric(sub("json_serie-sgs-", "", .x[ix]))
        } else {
          NA_integer_
        }
      })
    })

    output$page_count <- shiny::renderUI({
      shiny::tags$strong(paste0(page_count(), " results"))
    })

    output$results <- shiny::renderTable({
      df <- query_result()
      cmds <- sapply(query_codes(), function(x) {
        if (!is.na(x)) {
          paste0("rbcb::get_series(", x, ")")
        } else {
          "NA"
        }
      })
      data.frame(`Result Title` = df$title, Command = cmds, check.names = FALSE)
    })

    observeEvent(input$done, {
      shiny::stopApp(TRUE)
    })

  }

  app <- shiny::shinyApp(ui, server, options = list(quiet = TRUE))
  shiny::runGadget(app, viewer = shiny::dialogViewer("rbcb search"))
}

