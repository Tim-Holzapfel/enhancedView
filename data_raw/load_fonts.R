# Load Fonts --------------------------------------------------------------
library(extrafont)
pdfFonts <- grDevices::pdfFonts
# # TODO Uncomment the ttf_import line before handing in the thesis
extrafont::ttf_import(paths = "fonts/")
extrafont::loadfonts(quiet = TRUE)
