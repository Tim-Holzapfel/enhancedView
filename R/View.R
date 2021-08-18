#' Enhanced Data Viewer
#'
#' @description One of the biggest problems of the built-in data viewer is its
#'   limited capability to expand the columns.
#'
#' @param file File to be viewed
#' @param dev_mode Drop variables that are not relevant in most situations
#' @param standard_view Disables the enhanced view mode.
#' @param pageLength_default default page length.
#' @export
#'
#' @importFrom rlang .data
#' @importFrom shiny stopApp
#' @importFrom dplyr any_of
#'
#'
View <- function(file,
                 dev_mode = getOption(
                   "enhancedView.dev_mode",
                   default = FALSE
                 ),
                 standard_view = getOption(
                   "enhancedView.standard_view",
                   default = FALSE
                 ),
                 pageLength_default = getOption(
                   "enhancedView.pageLength",
                   default = 200
                 )) {
  requireNamespace("dplyr")

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
        dplyr::select(-any_of(.data$names_select))
    }

    requireNamespace("shiny", quietly = TRUE)
    requireNamespace("shinythemes", quietly = TRUE)

    data.table::setDTthreads(6)

    ui <- shiny::fluidPage(
      theme = shinythemes::shinytheme("flatly"),
      DT::DTOutput("mytable")
    )

    # Reduce the page length to 50 if the data table contains a lot of columns
    # to increase the loading speed


    # if (all(dim(file) > 100)) 20 else 50


    server <- function(input, output, session) {
      output$mytable <- DT::renderDT({
        DT::datatable(
          file,
          extensions = c("FixedHeader", "KeyTable"),
          options = list(
            deferRender = TRUE,
            keys = TRUE,
            columnDefs = list(
              list(
                className = "dt-center",
                targets = "_all"
              )
            ),
            pageLength = pageLength_default,
            lengthMenu = c(5, 20, 50, 100, 200, 1000),
            fixedHeader = TRUE,
            autoWidth = TRUE,
            language = list(search = "Filter:")
          )
        )
      })

      session$onSessionEnded(function() {
        stopApp()
      })
    }
    shiny::shinyApp(ui, server)
  } else if (any(class(file) %in% "environment")) {
    tibble::view(file)
  } else {
    file_rows <- nrow(file)

    if (file_rows <= 10000) {
      row_limit <- file_rows
    } else {
      row_limit <- 10000
    }

    file <-
      as.data.frame(file) %>%
      dplyr::slice(1:row_limit)

    file_name <- deparse(file)

    file <-
      file %>%
      dplyr::select(-any_of("geometry"))

    tibble::view(file)
  }
}
