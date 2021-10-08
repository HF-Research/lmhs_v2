library(data.table)
library(purrr)
library(stringr)
library(sp)
library(sf)
# LOAD DATA ---------------------------------------------------------------
dat <- fread(input = "data/export.txt", encoding = "Latin-1")
topics <- fread("data/topics.csv", encoding = "UTF-8")
struc <-
  fread("data/struc.txt", encoding = "Latin-1") %>% split(by = "person_type")
labels <-
  fread("data/labels.txt", encoding = "Latin-1") %>% split(by = "person_type")
scales <- fread("data/scales_description.csv", encoding = "UTF-8")
converted_binary <-
  fread("data/converted_binary.csv", encoding = "UTF-8")


# RECODE VARIABLES --------------------------------------------------------
dat[, non_strat := "strat"]
dat[strat == "non_stratified", non_strat := "non_strat"]
dat[strat == "non_stratified", strat := "Svar fordeling"]
dat[, converted_binary := 0]
dat[strat == "converted_binary", converted_binary := 1]
dat[strat == "converted_binary", strat := "Svar fordeling"]
dat[strat == "age_sex", strat := "Kon/alder"]
dat[Kon == "male", Kon := "Mand"]
dat[Kon == "female", Kon := "Kvinde"]
dat[, percent := round(percent, digits = 1)]
dat[, count := round(count)]
dat <- dat[!(strat == "Svar fordeling" & grepl("hq_", item))]
dat <- dat[!(patient_data == F & item == "s_1")]


dat_ls <- split(dat, by = "patient_data")
names(dat_ls) <- c("pat", "paar")

topics_ls <- split(topics, by = "survey")
stopifnot(names(dat_ls) == names(topics_ls))
stopifnot(names(dat_ls) == names(struc))

# MUNGE --------------------------------------------------------------------

# Clean-up struc datasets
struc <- imap(struc, function(i, nm) {
  i[is.na(question_integer), question_integer := as.integer(question_number)]
  if (nm == "paar") {
    i <-
      i[variableName != "s_1" & variableName != "s_80" &
          question_integer != 50]
  }
  i
})

# Merge Topic structure
dat_ls <-
  pmap(list(dat_ls, topics_ls, struc, labels), function(dat_i, topic_i, struc_i, labels_i) {
    for (i in seq_len(nrow(topic_i))) {
      struc_i[between(
        x = question_integer,
        lower = topic_i$question_start[i],
        upper = topic_i$question_end[i],
        incbounds = TRUE,
      ), `:=`(
        topic = topic_i[i]$topic,
        topic_en = topic_i[i]$en,
        topic_dk = topic_i[i]$dk
      )]
    }
    # Merge structure to data
    # Some questions are multipart (like disease q), so only need one entry for
    # multipart Q.
    struc_tmp <- struc_i[, .SD[1], by = questionName]

    out <- merge(dat_i,
                 struc_tmp[, .(
                   questionName,
                   questionText,
                   question_name_short,
                   topic,
                   topic_en,
                   topic_dk,
                   question_number
                 )],
                 by.x = "item",
                 by.y = "questionName",
                 all.x = TRUE)
    stopifnot(nrow(out) == nrow(dat_i))


    # Data that are non-stratified (and non converted binaries) use a different
    # data label (the terribly named 'non-cutpoint').

    x <- split(out, by = "non_strat")
    x <- x[c("non_strat", "strat")]
    labels_x <- split(labels_i, by = "type")
    names(x)
    names(labels_x)
    tmp <- map2(x, labels_x, function(dat, labs) {
      merge(
        dat,
        labs[, .(question, group, group_label, value, display)],
        by.x = c("item", "response"),
        by.y = c("question", "group_label"),
        all.x = TRUE
      )
    })
    out <- rbindlist(tmp)
    stopifnot(nrow(out) == nrow(dat_i))
    out[]
  })

dat <- rbindlist(dat_ls, idcol = "person_type")
dat[, patient_data := NULL]
dat <- merge(dat,
             scales,
             by.x = "item",
             by.y = "var_name",
             all.x = T)
dat[!is.na(var_name_new), `:=`(questionText = var_name_new, question_name_short =
                                 var_name_short)]

# TEXT FORMATTING ---------------------------------------------------------
# Extract everything from before the question mark
dat[, tmp := questionText]

dat[, questionText := str_extract(pattern = "^(.*?)\\?", string = questionText)]
dat[is.na(questionText), questionText := tmp]

# Remove some extra wording from question text
i <-
  grepl("\\.\\.\\. Sæt ét kryds i hver linje - ", dat$questionText)
dat[, questionText := gsub("\\.\\.\\. Sæt ét kryds i hver linje - ", " ", dat$questionText)]
dat[i, questionText := stringr::str_to_sentence(questionText)]

dat[, questionText := gsub(" - Andet, skriv venligst:", " ", dat$questionText)]

i <- grepl("Sæt ét eller flere kryds", dat$questionText)
dat[, questionText := gsub("Sæt ét eller flere kryds", " ", dat$questionText)]
dat[i, questionText := stringr::str_to_sentence(questionText)]

dat[, response := stringr::str_wrap(response, width = 30)]
dat[, strat_level := stringr::str_wrap(strat_level, width = 25)]

dat[, question_name_short := paste0(question_number, " ", question_name_short)]
# TITLES FOR STRAT RESPONESES ---------------------------------------------

title_phrase <- 'Andel som har svaret: '
dat[!is.na(strat_level), response := paste0(title_phrase, response)]

# CONVERTED BINARY --------------------------------------------------------

dat <-
  merge(
    dat,
    converted_binary,
    by.x = c("item", "person_type"),
    by.y = c("s_item", "person_type"),
    all.x = TRUE
  )
setnames(dat, "label", "converted_binary_response")

# Temporary dataset that will be merged onto the scales dataset later
col_names <- names(scales)
items <-
  dat[converted_binary == 1, .SD[1], by = question_name_short]$question_name_short
tmp <-
  matrix(ncol = length(col_names),
         nrow = length(items),
         as.character(NA))  %>% data.frame() %>% setDT()
setnames(tmp, col_names)
tmp[, `:=` (
  var_name = items,
  var_name_new = "Sådan læses figuren: ",
  var_name_short = items
)]

# Create text programatically
dat_tmp <-
  dat[converted_binary == 1, .SD[which.max(percent)], by = question_name_short]
dat_tmp[, converted_binary_text := paste0(
  "Figuren viser f.eks., at blandt alle dem, som har svaret på \"",
  response,
  "\", ",
  "har ",
  percent,
  "% svaret \"",
  converted_binary_response,
  "\""
)]
dat[converted_binary == 1, converted_binary_response := paste0("Andel som har svaret: ", converted_binary_response)]
# dat <- merge(dat, dat_tmp[,.(question_name_short, converted_binary_text)], by="question_name_short", all.x = TRUE)
# dat[, converted_binary_response:=paste0(converted_binary_response, ". ", converted_binary_text)]
# dat[, converted_binary_text:=NULL]
scales_tmp <-
  merge(tmp,
        dat_tmp[, .(question_name_short, converted_binary_text)] ,
        by.x = "var_name_short",
        by.y = "question_name_short",
        all.x = T)
scales_tmp[, text := converted_binary_text]
scales_tmp[, converted_binary_text := NULL]
scales <- rbind(scales, scales_tmp)
scales[, var_name_short := gsub(pattern = "[0-9]", '', var_name_short)] %>%
  .[, var_name_short := gsub(pattern = "^\\.", '', var_name_short)] %>%
  .[, var_name_short := str_trim(var_name_short)]

# TOPIC AND QUESTION ORDER ------------------------------------------------

# Get order in which Questions and Topics should appear in dropdown meneus
dat[, q_number := str_extract(dat$questionText, pattern = "^\\d*\\.\\d*\\.?\\d*")]
vars <- c(paste0("q_pos", 1:3))
dat[, (vars) := tstrsplit(q_number, split = ".", fixed = T)]
dat[, (vars) := map(.SD, as.numeric), .SDcols = vars]

# The scales don't have a number in the questionnare, and we want them at the
# end
dat[is.na(q_pos1), q_pos1 := as.numeric(question_number)]
setorder(dat, q_pos1, q_pos2, q_pos3)
dat[, ui_order := 1:nrow(dat)]

# SETUP UI CHOICES --------------------------------------------------------
# List topics that should be shown depending on person_type selected
topics_by_person <-
  split(dat, by = "person_type") %>% map(
    .x = .,
    .f = function(x) {
      x$topic_dk %>% unique()
    }
  )
# List questions that should be shown depending on which person_type and topic
# are selected
q_by_topic_person <-
  split(dat, by = c("person_type", "topic_dk")) %>% map(
    .x = .,
    .f = function(x) {
      x$question_name_short %>% unique()
    }
  )

# List the stratification levels that are available for each item
strat_by_item <-
  split(dat, by = c("person_type", "question_name_short")) %>% map(
    .x = .,
    .f = function(x) {
      x$strat %>% unique()
    }
  )


# CLEANUP --------------------------------------------------------------------
dat[, `:=`(
  q_number = NULL,
  q_pos1 = NULL,
  q_pos2 = NULL,
  q_pos3 = NULL,
  ui_order = NULL,
  tmp = NULL,
  display = NULL,
  topic_en = NULL,
  question_number = NULL,
  topic = NULL,
  var_name_new = NULL,
  text = NULL
)]
names(dat)
setcolorder(
  dat,
  neworder = c(
    "person_type",
    "item",
    "response",
    "strat_level",
    "percent",
    "count",
    "strat",
    "mean",
    "Kon",
    "Alder",
    "non_strat",
    "questionText",
    "question_name_short",
    "topic_dk",
    "group",
    "value"
  )
)



# MAP COLOR SCALE ---------------------------------------------------------
diff_percent <- function(x) {
  y <- x[, diff(range(x$percent, na.rm = T))]
  return(list(y, x$person_type[1]))
}
diff_mean <- function(x) {
  y <- x[, diff(range(x$mean, na.rm = T))]
  return(list(y, x$person_type[1]))
}
color_data  <- dat[strat == "Region" &
      !(grepl("HeartQol", question_name_short)), diff_percent(.SD[, .(percent, person_type)]), by =
      .(question_name_short,person_type)]
max_diff_percent <- color_data[, max(V1)]


color_data  <- dat[strat == "Region" &
                     (grepl("HeartQol", question_name_short)), diff_mean(.SD[, .(mean, person_type)]), by =
                     .(question_name_short,person_type)]

max_diff_mean <- color_data[, max(V1)]
max_diff_map_colors <- list("percent"=max_diff_percent, "mean"=max_diff_mean)
# GEO PREP
# SAVE --------------------------------------------------------------------
saveRDS(dat, file = "cached_data/dat.rds")
saveRDS(topics_by_person, file = "cached_data/topics_by_person.rds")
saveRDS(q_by_topic_person, "cached_data/q_by_topic_person.rds")
saveRDS(strat_by_item, "cached_data/strat_by_item.rds")
saveRDS(scales, file = "cached_data/scales.rds")
saveRDS(max_diff_map_colors, file = "cached_data/max_diff_map_colors.rds")

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
