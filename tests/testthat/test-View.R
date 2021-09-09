
library(testthat)
library(enhancedView)

context("view_compatibility")

test_data_df <- dplyr::starwars
test_data_mat <- as.matrix(test_data_df)


View(test_data_df)

