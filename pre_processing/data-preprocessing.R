library(data.table)
library(purrr)

# FAKE DATA ---------------------------------------------------------------

dat <- fread(input = "data/fake_data.csv")
dat[, stratification_value_2 := as.factor(stratification_value_2)]




# REAL DATA ---------------------------------------------------------------
dat <- fread(input = "data/export.txt", encoding = "UTF-8")
topics <- fread("data/topics.csv", encoding = "UTF-8")
dat[, respondant_type := "pat"]
dat[grepl("par|paar", type), respondant_type := "paar"]
dat_ls <- split(dat, by = "respondant_type")
topics_ls <- split(topics, by = "survey")
struc_pat <- fread("data/pat_struc.csv", encoding = "UTF-8")
struc_paar <- fread("data/paar_struc.csv", encoding = "UTF-8")
struc_pat[, survey := "pat"]
struc_paar[, survey := "paar"]
struc <- list(pat = struc_pat, paar = struc_paar)
stopifnot(names(dat_ls) == names(topics_ls))
stopifnot(names(dat_ls) == names(struc))
# PAT DATA ----------------------------------------------------------------
pmap(list(dat_ls, topics_ls, struc), function(dat_i, topic_i, struc_i) {


  for (i in seq_len(nrow(topic_i))) {
    struc_i[between(
      x = question_integer,
      lower = topic_i$question_start[i],
      upper = topic_i$question_end[i],
      incbounds = TRUE,
    ), `:=`(topic_en = topic_i[i]$en, topic_dk = topic_i[i]$dk)]
  }
  struc_i[is.na(topic_en), `:=`(topic_en = topic_i[en == "health", en],
                               topic_dk = topic_i[en == "health", dk])]

})
merge(dat[respondant_type == "pat"],
      struc_pat,
      by.x = "item",
      by.y = "questionName",
      all.x = TRUE)



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
