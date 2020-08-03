#' Enhanced Data Viewer
#'
#' @description One of the biggest problems of the built-in data viewer is its
#'   limited capability to expand the columns.
#'
#' @param file File to be viewed
#' @param dev_mode Drop variables that are not relevant in most situations
#' @param standard_view Disables the enhanced view mode.
#'
#' @export
#'
View <- function(
                 file,
                 dev_mode = getOption(
                   "enhancedView.dev_mode",
                   default = FALSE
                 ),
                 standard_view = getOption(
                   "enhancedView.standard_view",
                   default = FALSE
                 )) {

  # Only invoke the enhanced data viewer when the data of interest is a
  # data.frame

  if (any(class(file) %in% "data.frame") & standard_view == FALSE) {

    # Drop some variables that are only relevant in a development context
    # and are otherwise just cluttering the viewer.

    if (dev_mode == FALSE) {
      requireNamespace("dplyr")

      names <- getOption(
        "enhancedView.names",
        default = NULL
      )

      names_select <- names[which(names %in% names(file))]

      file <-
        file %>%
        dplyr::select(-any_of(names_select))
    }

    requireNamespace("shiny")
    requireNamespace("shinythemes")

    # conflicted::conflict_prefer("renderDT", "DT", quiet = TRUE)
    # conflicted::conflict_prefer("dataTableOutput", "DT", quiet = TRUE)
    # conflicted::conflict_prefer("renderDataTable", "DT", quiet = TRUE)
    # conflicted::conflict_prefer("DTOutput", "DT", quiet = TRUE)

    data.table::setDTthreads(6)

    ui <- shiny::fluidPage(
      theme = shinythemes::shinytheme("flatly"),
      DT::DTOutput("mytable")
    )

    server <- function(input, output) {
      output$mytable <- DT::renderDT({
        DT::datatable(
          file,
          style = "bootstrap",
          extensions = c("FixedHeader", "Buttons"),
          options = list(
            columnDefs = list(
              list(
                className = "dt-center",
                targets = "_all"
              )
            ),
            pageLength = 200,
            lengthMenu = c(5, 20, 50, 100, 200, 1000),
            fixedHeader = TRUE,
            autoWidth = TRUE,
            dom = "Bfrtip",
            buttons = I("colvis"),
            language = list(search = "Filter:")
          )
        )
      })
    }
    shiny::shinyApp(ui, server)
  } else {
    tibble::view(file)
  }
}
