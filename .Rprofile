


if (interactive()) {
  suppressMessages({
    require(devtools)
    require(usethis)
    require(magrittr)
  })

  invisible(desc::desc_del_deps())

  deps <- renv::dependencies(path = "R") %>%
    dplyr::transmute(
      package = Package,
      type = "Imports",
      version = "*"
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
