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
  # devtools::install_github("ropensci/plotly")
  library(plotly)
  library(magrittr)
})

# LOAD R CODE -------------------------------------------------------------
# This should be done automatically in shiny versions >= 1.5
# However, on deployment to shinyapps, it seems these codes are note loaded
files <- list.files(path = "R/", full.names = TRUE)
sapply(files, source)

data <- list.files(path = "cached_data/", full.names = TRUE)
data_names <- list.files(path = "cached_data/")
data_names <- gsub(pattern = ".rds",replacement = "", data_names)
d <- lapply(data, readRDS)
names(d) <- data_names


# GRAPH PARAMETERS ------------------------------------------------------------
male_color <- "#19b9b1"
female_color <- "#ea8438"
hfBlue <- "#002A3A"
graph_colors <- c(male_color, female_color)
rm(male_color, female_color)

axis_font_size <- 20
legend_font_size <- 17
tick_font_size <- 15
num_digits <- 0

