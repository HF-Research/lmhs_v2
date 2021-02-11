# LIBRARIES ----------------------------------------------------
# devtools::install_github("rstudio/profvis")
# library(profvis)
# remotes::install_github("rstudio/reactlog")
library(reactlog)
# reactlog_enable()
# devtools::install_version("shiny", version = "1.5.0")
suppressPackageStartupMessages({
  library(shiny)
  library(DT)
  library(shinyWidgets)
  library(data.table)
  library(shinyjs) # Hides un-used tabs
  library(manipulateWidget)
  # devtools::install_github("ropensci/plotly")
  library(plotly)
  library(magrittr)
})

# LOAD R CODE -------------------------------------------------------------
# This should be done automatically in shiny versions >= 1.5
# However, on deployment to shinyapps, it seems these codes are note loaded
files <- list.files(path = "R/", full.names = TRUE)
sapply(files, source)


