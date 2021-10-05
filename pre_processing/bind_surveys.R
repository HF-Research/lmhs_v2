# # library(data.table)
# library(magrittr)
# library(Publish)
# library(purrr)
# library(haven)
# # PATIENT DATA ------------------------------------------------------------
# hads_data <-
#   fread(
#     "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/Patient_HADS_foerst/dataset.csv",
#     colClasses = list("character" = "cpr",
#                       "character" = "lobnr")
#   )
# who_data <-
#   fread(
#     "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/Patient_WHO_foerst/dataset.csv",
#     colClasses = list("character" = "cpr",
#                       "character" = "lobnr")
#   )
# who_pilot <- readxl::read_xlsx(
#   "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/Data_patient_pilot.xlsx",
#   sheet = "Dataset(1),(1)"
# ) %>% setDT()
#
# str_pat <- fread(
#   "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/Patient_WHO_foerst/structure.csv"
# )
# # Sort hads by the order of questions found in WHO
# setcolorder(hads_data, neworder = names(who_data))
# names(hads_data) == str_pat$variableName
# hads_data[, survey_order := "hads"]
# who_data[, survey_order := "who"]
# out_patient <- rbind(who_data, hads_data)
# out_patient[, .(cpr)] %>% str()
#
# # Pilots all have who first
# who_pilot[, `:=`(
#   s_160 = NULL,
#   s_273 = NULL,
#   starttim = NULL,
#   closetim = NULL,
#   difftime = NULL
# )]
# who_pilot[, survey_order := "pilot"]
# who_pilot[, cpr := as.character(cpr)]
# who_pilot[, lobnr := as.character(lobnr)]
# who_pilot <- who_pilot[!is.na(cpr)]
# names(who_pilot) == names(out_patient)
# out_patient <- rbind(out_patient, who_pilot)
#
# # PAAROERENDE DATA --------------------------------------------------------
# hads_data <-
#   fread(
#     "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/Paaroerende_HADS_foerst/dataset.csv",
#     colClasses = list("character" = "cpr",
#                       "character" = "lobnr")
#   )
# who_data <-
#   fread(
#     "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/Paaroerende_WHO_foerst/dataset.csv",
#     colClasses = list(
#       "character" = "s_170",
#       "character" = "cpr",
#       "character" = "lobnr"
#     )
#   )
# who_pilot <- readxl::read_xlsx(
#   "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/Data_paaaroerende_pilot.xlsx",
#   sheet = "Dataset"
# ) %>% setDT()
#
# str_paar <- fread(
#   "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/Paaroerende_WHO_foerst/structure.csv"
# )
# setcolorder(hads_data, neworder = names(who_data))
# names(hads_data) == str_paar$variableName
# hads_data[, survey_order := "hads"]
# who_data[, survey_order := "who"]
#
# out_paar <- rbind(who_data, hads_data)
# who_pilot[, `:=`(
#   s_130 = NULL,
#   s_140 = NULL,
#   closetim = NULL,
#   starttim = NULL,
#   difftime = NULL
# )]
# who_pilot[, survey_order := "pilot"]
# who_pilot[, lobnr := as.character(lobnr)]
# names(who_pilot) == names(who_data)
# out_paar <- rbind(out_paar, who_pilot)
#
# # REDODE HADS PAPER TO WHO ------------------------------------------------
# # Any lobnmr in HADS who received paper questionnare should be coded as WHO,
# # because all paper was WHO
# paper <-
#   readxl::read_xlsx(
#     "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/Loebenumre paa indtastede papirskemaer.xlsx",
#     col_types = "text"
#   ) %>% setDT()
#
# out_patient[survey_order == "hads"][lobnr %in% paper$Patientskemaer, survey_order := "who"]
# out_paar[survey_order == "hads"][lobnr %in% paper$Paaroerendeskemaer, survey_order := "who"]
#
# out_patient[, survey_type := "electronic"]
# out_patient[lobnr %in% paper$Patientskemaer, survey_type := "paper"]
#
# out_paar[, survey_type := "electronic"]
# out_paar[lobnr %in% paper$Paaroerendeskemaer, survey_type := "paper"]
# # Some lobnr are entered twice in the paper excel file
#
#
# # ADD SURVEY DURATION INFORMATION -----------------------------------------
# out <-
#   list.files(
#     "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/",
#     pattern = ".xlsx",
#     full.names = TRUE
#   )
# dur_paar <-
#   purrr::map_df(out[1:3],
#                 readxl::read_xlsx,
#                 sheet = "Dataset",
#                 col_types = "text") %>% setDT()
#
# dur_patient <- purrr::map_df(out[4:6],
#                              readxl::read_xlsx,
#                              sheet = "Dataset(1),(1)",
#                              col_types = c("text")) %>% setDT()
# dur_patient <- dur_patient[, .(lobnr, closetim, starttim, difftime)]
# dur_paar <- dur_paar[, .(lobnr, closetim, starttim, difftime)]
#
# out_patient <-
#   merge(out_patient, dur_patient, by = "lobnr", all.x = TRUE)
# out_paar <- merge(out_paar, dur_paar, by = "lobnr", all.x = TRUE)
#
# # ADD LEADING 0s TO CPR ---------------------------------------------------
# out_patient[nchar(cpr) < 10, cpr := paste0("0", cpr)]
# nrow(out_patient[nchar(cpr) != 10]) == 0
#
# out_paar[nchar(cpr) < 10, cpr := paste0("0", cpr)]
# nrow(out_paar[nchar(cpr) != 10]) == 0
#
# out_paar[nchar(s_170) == 9, s_170 := paste0("0", s_170)]
# out_paar[grep("-", s_170), s_170:= gsub("-", "", s_170)]
# nrow(out_paar[nchar(s_170) != 10]) == 0
#
#
# # REMOVE FREE TEXT FIELDS -------------------------------------------------
# txt_vars <-
#   names(out_patient)[out_patient[, map_lgl(.SD, is.character)]]
# out_patient[, ..txt_vars]
# str_pat[variableName %in% txt_vars]
# out_patient[, `:=`(
#   s_2 = NULL,
#   s_228 = NULL,
#   s_232 = NULL,
#   s_15 = NULL,
#   s_75 = NULL,
#   s_261 = NULL,
#   s_80 = NULL,
#   s_265 = NULL,
#   s_3 = NULL
# )]
#
# txt_vars <- names(out_paar)[out_paar[, map_lgl(.SD, is.character)]]
# out_paar[, ..txt_vars]
# str_paar[variableName %in% txt_vars]
# out_paar[, `:=`(s_1 = NULL, s_2 = NULL)]
#
# # ERROR CHECKING ----------------------------------------------------------
# nrow(out_paar[duplicated(lobnr)])
# out_paar[duplicated(cpr)]
# out_patient[duplicated(lobnr)]
# out_patient[duplicated(cpr)]
#
#
# # CHECK DATA --------------------------------------------------------------
# names(out_paar)
# out_paar$survey_orders
# univariateTable(formula = ~ survey_type + survey_order,
#                 data = out_paar)
# univariateTable(
#   formula = ~ survey_type + survey_order + s_1_1 + s_1_2 + s_1_3 + s_1_4,
#   data = out_patient
# )
#
# # SUMMARY OF VARIABLES ----------------------------------------------------
#
# # Summarize integer variables
# var_summary <- function(x) {
#   num_vars <-
#     names(x)[x[, map_lgl(.SD, is.numeric)]]
#
#   var_summary <- map(x[, ..num_vars], function(x) {
#     # browser()
#     unique(x) %>%
#       sort(na.last = TRUE) %>%
#       paste0(collapse = ", ") %>%
#       data.table("description" =
#                    .)
#   }) %>% rbindlist(idcol = "variable")
#   var_summary[, description := paste0("Integer, unique values: ", description)]
#
#   # Summarize text variables
#   txt_vars <-
#     names(x)[x[, map_lgl(.SD, is.character)]]
#   txt_summary <- data.table("variable" = txt_vars,
#                             "description" = "Charater string")
#   rbind(txt_summary, var_summary)
# }
# var_summary_pat <- var_summary(out_patient)
# var_summary_paar <- var_summary(out_paar)
#
#
# # REORDER VARIABLES TO MATCH VARIABLE SUMMARY-----------------------------------
# txt_vars <-
#   names(out_patient)[out_patient[, map_lgl(.SD, is.character)]]
#
# out_patient[, ..txt_vars]
# setcolorder(out_patient, txt_vars)
# names(out_patient)
#
#
# txt_vars <-
#   names(out_paar)[out_paar[, map_lgl(.SD, is.character)]]
# out_paar[, ..txt_vars]
# setcolorder(out_paar, txt_vars)
# names(out_paar)
#
#
# # WRITE DATA TO DISK ------------------------------------------------------
# write.csv2(out_patient,
#            file = "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/dst/patient_data.csv",
#            row.names = FALSE)
# write.csv2(out_paar,
#            file = "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/dst/paar_data.csv",
#            row.names = FALSE)
# write.csv2(var_summary_pat,
#            file = "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/dst/not_for_upload_variable_summary_patient.csv",
#            row.names = FALSE)
# write.csv2(var_summary_pat,
#            file = "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/dst/not_for_upload_variable_summary_paar.csv",
#            row.names = FALSE)
# path_patient_sas <- "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/dst/patient_data.sas"
# path_patient <- "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/dst/patient_data.txt"
# path_paar_sas <- "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/dst/paar_data.sas"
# path_paar <- "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/dst/paar_data.txt"
#
# library(foreign)
# write.foreign(out_patient,
#               datafile = path_patient,
#               codefile = path_patient_sas,
#               package  = "SAS")
# write.foreign(out_paar,
#               datafile = path_paar,
#               codefile = path_paar_sas,
#               package  = "SAS")
#
