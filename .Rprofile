
if (interactive()) {
  suppressMessages({
    require(devtools)
    require(usethis)
    require(magrittr)
    devtools::load_all(".")
  })

  invisible(desc::desc_del_deps())

  deps <- renv::dependencies(path = c("R")) %>%
    dplyr::transmute(
      package = Package,
      type = "Imports",
      version = "*"
    ) %>%
    tibble::add_row(
      package = "testthat", type = "Imports", version = "*"
    ) %>%
    tibble::add_row(
      package = "rlang", type = "Imports", version = "*"
    ) %>%
    tibble::add_row(
      package = "magrittr", type = "Imports", version = "*"
    ) %>%
    tibble::add_row(
      package = "DT", type = "Imports", version = "*"
    ) %>%
    tibble::add_row(
      package = "shiny", type = "Imports", version = "*"
    ) %>%
    tibble::add_row(
      package = "shinythemes", type = "Imports", version = "*"
    ) %>%
    tibble::add_row(
      package = "R", type = "Depends", version = ">= 4.0.0"
    ) %>%
    unique()

  invisible(desc::desc_set_deps(deps))

  rm(list = "deps")
}



