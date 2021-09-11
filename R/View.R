#' Enhanced Data Viewer
#'
#' @description One of the biggest problems of the built-in data viewer is its
#'   limited capability to expand the columns.
#'
#' @param file File to be viewed
#' @param theme Shinytheme to use. Possible values are "cerulean", "cosmo", "cyborg", "darkly", "flatly", "journal", "lumen", "paper", "readable", "sandstone", "simplex", "slate", "spacelab", "superhero", "united" or "yeti". The default is "flatly".
#' @param pageLength default page length.
#' @param default_view Request the default RStudio data viewer.
#' @export
#'
#' @import shiny
#' @importFrom dplyr any_of
#' @importFrom shinythemes shinytheme
View <-
  function(file,
           pageLength = getOption(
             "enhancedView.pageLength",
             default = 200
           ),
           default_view = getOption(
             "enhancedView.default_view",
             default = FALSE
           ),
           theme = getOption(
             "enhancedView.theme",
             default = "flatly"
           )) {
    withr::with_package("utils", {
      standardView <- as.environment("package:utils")$View
    })

    # Only invoke the enhanced data viewer when the data of interest is a
    # data.frame

    none <- Negate(any)
    if (none(class(file) %in% "data.frame") | default_view) {
      standardView(file)
      return(NULL)
    }

    # If package "parallel" is installed then use it to determine how many
    # non-logical cores are available.

    if (requireNamespace("parallel", quietly = TRUE)) {
      cores <- parallel::detectCores(logical = FALSE)
      data.table::setDTthreads(cores)
    }

    ui <- shiny::fluidPage(
      theme = shinythemes::shinytheme(theme),
      DT::DTOutput("mytable")
    )

    server <- function(input, output, session) {
      output$mytable <- DT::renderDT({
        DT::datatable(
          file,
          style = "bootstrap",
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
            pageLength = pageLength,
            lengthMenu = c(3, 5, 20, 50, 100, 200, 1000),
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
  }
