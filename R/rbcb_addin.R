
#' rbcb Search
#'
#' @description `rbcb_search(text)` opens an [RStudio
#'   gadget](https://shiny.rstudio.com/articles/gadgets.html) and
#'   [addin](http://rstudio.github.io/rstudioaddins/) that allows you to query
#'   for specific terms and see a suitable rbcb command to fetch the
#'   desired data.
#'
#' @param text text to search
#'
#' @return Addin has no return
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
      data <- fromJSON(content(res, as = "text"))
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
      data.frame(
        `Result Title` = df$title,
        Name = df$name,
        Command = cmds, check.names = FALSE
      )
    })

    shiny::observeEvent(input$done, {
      shiny::stopApp(TRUE)
    })
  }

  app <- shiny::shinyApp(ui, server, options = list(quiet = TRUE))
  shiny::runGadget(app, viewer = shiny::dialogViewer("rbcb search"))
}


#' rbcb dataset
#'
#' @description `rbcb_dataset(name)` opens an [RStudio
#'   gadget](https://shiny.rstudio.com/articles/gadgets.html) and
#'   [addin](http://rstudio.github.io/rstudioaddins/) that allows you to view
#'   a few attributes that help to explain the desired data.
#'
#' @param name dataset name
#'
#' @return Addin has no return
#'
#' @export
rbcb_dataset <- function(name) {
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("rbcb dataset"),
    miniUI::miniContentPanel(
      shiny::htmlOutput("title"),
      shiny::tags$br(),
      shiny::htmlOutput("name"),
      shiny::tags$br(),
      shiny::htmlOutput("author"),
      shiny::tags$br(),
      shiny::htmlOutput("url"),
      shiny::tags$br(),
      shiny::htmlOutput("notes"),
    )
  )

  server <- function(input, output, session) {
    query_result <- shiny::reactive({
      url <- paste0("https://dadosabertos.bcb.gov.br/api/rest/dataset/", name)
      res <- GET(url)
      fromJSON(content(res, as = "text"))
    })

    output$title <- shiny::renderUI({
      data <- query_result()
      shiny::tags$div(
        shiny::tags$strong("Title: "),
        data$title
      )
    })

    output$name <- shiny::renderUI({
      data <- query_result()
      shiny::tags$div(
        shiny::tags$strong("Name: "),
        name
      )
    })

    output$author <- shiny::renderUI({
      data <- query_result()
      shiny::tags$div(
        shiny::tags$strong("Author: "),
        data$author
      )
    })

    output$url <- shiny::renderUI({
      data <- query_result()
      shiny::tags$div(
        shiny::tags$strong("URL: "),
        shiny::tags$a(data$ckan_url, href = data$ckan_url)
      )
    })

    output$notes <- shiny::renderUI({
      data <- query_result()
      shiny::tags$div(
        shiny::tags$strong("Description: "),
        shiny::tags$br(),
        shiny::HTML(data$notes_rendered)
      )
    })

    shiny::observeEvent(input$done, {
      shiny::stopApp(TRUE)
    })
  }

  app <- shiny::shinyApp(ui, server, options = list(quiet = TRUE))
  shiny::runGadget(app, viewer = shiny::dialogViewer("rbcb dataset"))
}