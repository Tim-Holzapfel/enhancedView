#' Enhanced Data Viewer
#'
#' @description One of the biggest problems of the built-in data viewer is its
#'   limited capability to expand the columns.
#'
#' @param file File to be viewed
#' @param theme Drop variables that are not relevant in most situations
#' @param pageLength_default default page length.
#' @param default_view Request the default RStudio data viewer.
#' @export
#'
#' @importFrom rlang .data
#' @import shiny
#' @importFrom dplyr any_of
#' @importFrom shinythemes shinytheme
View <-
  function(file,
           pageLength_default = getOption(
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

    `%notin%` <- Negate(`%in%`)
    none <- Negate(any)

    requireNamespace("dplyr")

    # Only invoke the enhanced data viewer when the data of interest is a
    # data.frame

    withr::with_package("utils", {
      standardView <- as.environment("package:utils")$View
    })

    if (none(class(file) %in% "data.frame") | default_view) {
      standardView(file)
      return(NULL)
    }


    requireNamespace("shiny", quietly = TRUE)
    requireNamespace("shinythemes", quietly = TRUE)

    cores <- parallel::detectCores(logical = FALSE)

    data.table::setDTthreads(cores)

    ui <- shiny::fluidPage(
      theme = shinythemes::shinytheme(theme),
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
  }







#     else {
#     file_rows <- nrow(file)
#
#     if (file_rows <= 10000) {
#       row_limit <- file_rows
#     } else {
#       row_limit <- 10000
#     }
#
#     file <-
#       as.data.frame(file) %>%
#       dplyr::slice(1:row_limit)
#
#     file_name <- deparse(file)
#
#     file <-
#       file %>%
#       dplyr::select(-any_of("geometry"))
#
#     tibble::view(file)
#   }
# }
