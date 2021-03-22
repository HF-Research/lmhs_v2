library(data.table)
library(purrr)

# FAKE DATA ---------------------------------------------------------------

dat <- fread(input = "data/fake_data.csv")
dat[, stratification_value_2 := as.factor(stratification_value_2)]


# List topics that should be shown depending on person_type selected
topics_by_person <-
  split(dat, by = "person_type") %>% map(
    .x = .,
    .f = function(x) {
      x$topic %>% unique()
    }
  )
# List questions that should be shown depending on which person_type and topic
# are selected
q_by_topic_person <-
  split(dat, by = c("person_type", "topic")) %>% map(
    .x = .,
    .f = function(x) {
      x$question %>% unique()
    }
  )

saveRDS(dat, file = "cached_data/dat.rds")
saveRDS(topics_by_person, file = "cached_data/topics_by_person.rds")
saveRDS(q_by_topic_person, "cached_data/q_by_topic_person.rds")

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
