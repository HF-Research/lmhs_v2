ui_main_title <- "Results"
ui_about_tite <- "Methods"

choose_person_type <- enc2utf8("Choose respondent type")
person_type_choices <- enc2utf8(c("patient", "paaroerende"))
names(person_type_choices) <- enc2utf8(c("Patient", "Pårørende"))

choose_topic <- enc2utf8("Vælg emne")
choose_question <- enc2utf8("Vælg spørgsmål")
choose_stratification <- enc2utf8("Stratifikationer")
stratification_choices <- c("age_sex", "diag", "edu", "region")
names(stratification_choices) <-
  enc2utf8(c("Køn & alder", "Hjertesygdom", "Uddannelse", "Region"))
# question_choices


# OUTPUT ------------------------------------------------------------------

ui_plot_title <- "Results"
