# Code to create the package logo

usethis::use_readme_rmd()

#   ____________________________________________________________________________
#   Libraries                                                               ####

library(png)
library(magick)
library(hexSticker)
library(ggplot2)
library(magrittr)

project_root <- rprojroot::find_root(criterion = rprojroot::has_file("DESCRIPTION"))

#   ____________________________________________________________________________
#   Code                                                                    ####

# svglite::svglite("mag.svg")
# mag_ico <- icongram::igram(
#   icon = "magnify",
#   lib = "material"
# )


data <- tibble::tibble(
  x = 1,
  y = 1
)

img <- magick::image_read_svg("inst/extdata/magnify.svg") %>%
  magick::image_transparent(
    color = "#FFFFFF",
    fuzz = 20
  )

p <- ggplot2::ggplot(data) +
  ggplot2::theme_void() +
  hexSticker::theme_transparent() +
  annotation_raster(img, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf, interpolate = TRUE)


temp_logo <- tempfile(fileext = ".png")

ico_path <- file.path(project_root, "man/figures/logo.ico")

png_path <- file.path(project_root, "man/figures/logo.png")



hexSticker::sticker(p,
  package = "enhancedView",
  p_size = 15,
  p_x = 1,
  p_y = 1,
  l_x = 1.398, # x position for spotlight
  l_y = 0.9, # y position for spotlight
  s_x = 1.55,
  s_y = 0.9,
  s_width = 1, # width for subplot
  s_height = 1, # height for subplot
  spotlight = TRUE,
  filename = temp_logo,
  h_fill = "#E72424", # Fill Color Hexagon
  h_color = "#9A4E4E", # Color Border
  p_color = "#FBFFF1", # Color Package Name
  white_around_sticker = TRUE,
  url = "https://github.com/Tim-Lukas-H/enhancedView",
  u_color = "#FBFFF1", # URL Color
  u_family = "Roboto_Condensed", # font family for url
  u_size = 2
)

logo_transparent <-
  magick::image_read(
    temp_logo,
    depth = 16
  ) %>%
  magick::image_transparent(
    color = "#FFFFFF",
    fuzz = 20
  )

magick::image_write(
  logo_transparent,
  format = "png",
  quality = 100,
  depth = 16,
  flatten = FALSE,
  path = png_path
)

magick::image_resize(
  logo_transparent,
  geometry = "221x256"
) %>%
  magick::image_transparent(
    color = "#FFFFFF",
    fuzz = 20
  ) %>%
  magick::image_enhance() %>%
  magick::image_write(
    format = "ico",
    quality = 100,
    depth = 16,
    flatten = FALSE,
    path = file.path(project_root, "inst/extdata/logo/logo.ico")
  )
