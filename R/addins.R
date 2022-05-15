
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

    observeEvent(input$previous_page, {
      offset(max(offset() - 10, 0))
    })

    observeEvent(input$next_page, {
      offset(offset() + 10)
    })

    observeEvent(input$first_page, {
      offset(0)
    })

    observeEvent(input$last_page, {
      offset(floor(page_count() / 10) * 10)
    })

    observeEvent(input$q, {
      offset(0)
    })

    query_result <- shiny::reactive({
      data <- search_datasets(q = input$q, offset = offset())
      page_count(data$count)
      data$results
    })

    query_codes <- shiny::reactive({
      x <- query_result()
      sapply(x, function(.x) {
        if (is.null(.x$extras$codigo_sgs)) {
          NA_integer_
        } else {
          as.integer(.x$extras$codigo_sgs)
        }
      })
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
        if (as.character(x) != "" && length(as.character(x))) {
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
      dataset_info(name)
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