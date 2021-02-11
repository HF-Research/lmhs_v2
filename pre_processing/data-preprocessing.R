library(data.table)


# CSS PREPERATION ---------------------------------------------------------

# In order to have a common CSS template for all HFs shiny apps, we create use a
# common css template that has all classes and such defined. Any references to
# element IDs goes in the second, app specific css file.
css_common <-
  readLines(con = "https://raw.githubusercontent.com/matthew-phelps/hf-css/main/css-main.css")
css_app_specific <-
  readLines(con = "https://raw.githubusercontent.com/matthew-phelps/hf-css/main/ht-css.css")

writeLines(text = c(css_common, css_app_specific),
           con = "www/css-app-specifc.css")
