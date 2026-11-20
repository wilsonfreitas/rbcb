
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
      shiny::htmlOutput("page_count"),
      shiny::br(),
      shiny::div(
        shiny::strong("Pagination:"), shiny::br(),
        shiny::actionButton("first_page", "<<"),
        shiny::actionButton("previous_page", "<"),
        shiny::span(""),
        shiny::actionButton("next_page", ">"),
        shiny::actionButton("last_page", ">>")
      ),
      shiny::tags$hr(),
      shiny::tableOutput("results")
    )
  )

  server <- function(input, output, session) {
    page_count <- shiny::reactiveVal(0)
    offset <- shiny::reactiveVal(0)

    shiny::observeEvent(input$previous_page, {
      offset(max(offset() - 10, 0))
    })

    shiny::observeEvent(input$next_page, {
      offset(offset() + 10)
    })

    shiny::observeEvent(input$first_page, {
      offset(0)
    })

    shiny::observeEvent(input$last_page, {
      offset(floor(page_count() / 10) * 10)
    })

    shiny::observeEvent(input$q, {
      offset(0)
    })

    query_result <- shiny::reactive({
      data <- search_datasets(q = input$q, offset = offset())
      page_count(data$count)
      data$results
    })

    output$page_count <- shiny::renderUI({
      page <- as.integer(offset() / 10) + 1L
      pages <- ceiling(page_count() / 10)
      pages_str <- sprintf("(%d/%d pages)", page, pages)
      shiny::span(
        page_count(), "results", pages_str
      )
    })

    output$results <- shiny::renderTable({
      df <- query_result()
      if (nrow(df) == 0) {
        return(NULL)
      }
      cmds <- sapply(df$cod_sgs, function(x) {
        if (!is.na(x) && x != "") {
          paste0("rbcb::get_series(", x, ")")
        } else {
          "NA"
        }
      })
      tibble(
        `Result Title` = df$title,
        Id = df$name,
        Organization = df$organization,
        Frequency = df$frequency,
        Units = df$units,
        Start = df$from,
        End = df$to,
        Command = cmds
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
#' @param name dataset id (as shown by `rbcb_search()`) or name
#'
#' @return Addin has no return
#'
#' @export
rbcb_dataset <- function(name) {
  data <- tryCatch(dataset_info(name), rbcb_http_error = function(e) {
    if (e$status != 404) stop(e)
    stop("Dataset not found: '", name, "'. ",
      "Use the dataset id shown by rbcb_search().",
      call. = FALSE
    )
  })

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
    output$title <- shiny::renderUI({
      shiny::tags$div(
        shiny::tags$strong("Title: "),
        data$title
      )
    })

    output$name <- shiny::renderUI({
      shiny::tags$div(
        shiny::tags$strong("Name: "),
        name
      )
    })

    output$author <- shiny::renderUI({
      shiny::tags$div(
        shiny::tags$strong("Author: "),
        data$author
      )
    })

    output$url <- shiny::renderUI({
      shiny::tags$div(
        shiny::tags$strong("URL: "),
        shiny::tags$a(
          paste0("https://dadosabertos.bcb.gov.br/dataset/", data$name),
          href = paste0("https://dadosabertos.bcb.gov.br/dataset/", data$name)
        )
      )
    })

    output$notes <- shiny::renderUI({
      shiny::tags$div(
        shiny::tags$strong("Description: "),
        shiny::tags$br(),
        data$notes
      )
    })

    shiny::observeEvent(input$done, {
      shiny::stopApp(TRUE)
    })
  }

  app <- shiny::shinyApp(ui, server, options = list(quiet = TRUE))
  shiny::runGadget(app, viewer = shiny::dialogViewer("rbcb dataset"))
}