#' Enhanced Data Viewer
#'
#' @description One of the biggest problems of the built-in data viewer is its
#'   limited capability to expand the columns.
#'
#' @param file File to be viewed
#'
#' @import shiny
#' @import shinythemes
#'
#' @export
#'
View <- function(file) {
  requireNamespace("shiny")
  requireNamespace("data.table")
  requireNamespace("DT")
  requireNamespace("shinythemes")

  data.table::setDTthreads(8)

  ui <- shiny::fluidPage(
    theme = shinythemes::shinytheme("flatly"),
    DT::DTOutput("mytable")
  )

  server <- function(input, output) {
    output$mytable <- DT::renderDT({
      DT::datatable(
        file,
        style = "bootstrap",
        options = list(
          columnDefs = list(
            list(
              className = "dt-center",
              targets = "_all"
            )
          ),
          pageLength = 200,
          lengthMenu = c(5, 20, 50, 100, 200, 1000),
          autoWidth = TRUE,
          language = list(search = "Filter:")
        )
      )
    })
  }
  shiny::shinyApp(ui, server)
}
