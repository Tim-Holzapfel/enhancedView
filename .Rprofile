


if (interactive()) {
  suppressMessages({
    require(devtools)
    require(usethis)
    require(magrittr)
  })

  invisible(desc::desc_del_deps())

  deps <- renv::dependencies(path = "R") %>%
    dplyr::select("package" = "Package") %>%
    unique() %>%
    dplyr::mutate(
      type = "Imports",
      version = "*"
    ) %>%
    tibble::add_row(
      package = "R", type = "Depends", version = ">= 4.0.0"
    )

  invisible(desc::desc_set_deps(deps))

  rm(list = "deps")
}
