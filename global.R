# LIBRARIES ----------------------------------------------------
# devtools::install_github("rstudio/profvis")
# library(profvis)
# remotes::install_github("rstudio/reactlog")
# library(reactlog)
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


# GRAPH PARAMETERS --------------------------------------------------------
hfBlue <- "#002A3A"

male_color <- "#19b9b1"
female_color <- "#ea8438"
graph_colors <- c(male_color, female_color)
rm(male_color, female_color)

single_val_col <- hfBlue

DT_background_color <- "#002A3A"
DT_background_color <- "#193f4d"
DT_background_color <- "white"
DT_text_color <- hfBlue

# STARTING VALUES ---------------------------------------------------------

starting_vals_strat <- make_strat_choices(
  d=d,
  person_type = "pat",
  question_name_short = "hads_anxiety"
)


lang = "dk"
if (lang == "dk") {
  thousands_sep <- "."
  dec_mark <- ","
} else {
  thousands_sep <- ","
  dec_mark <- "."
}

