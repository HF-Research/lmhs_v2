library(data.table)
library(magrittr)

patient <- FALSE
if(patient){
hads_complete <-
  fread(
    "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/Patient_HADS_foerst/complete.csv"
  )
who_complete <-
  fread(
    "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/Patient_WHO_foerst/complete.csv"
  )
hads_data <-
  fread(
    "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/Patient_HADS_foerst/dataset.csv"
  )
who_data <-
  fread(
    "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/Patient_WHO_foerst/dataset.csv"
  )
who_str <- fread(
  "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/Patient_WHO_foerst/structure.csv"
)
hads_str <- fread(
  "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/Patient_HADS_foerst/structure.csv"
)
} else{
  hads_complete <-
    fread(
      "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/Paaroerende_HADS_foerst/complete.csv"
    )
  who_complete <-
    fread(
      "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/Paaroerende_WHO_foerst/complete.csv"
    )
  hads_data <-
    fread(
      "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/Paaroerende_HADS_foerst/dataset.csv"
    )
  who_data <-
    fread(
      "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/Paaroerende_WHO_foerst/dataset.csv"
    )
  who_str <- fread(
    "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/Paaroerende_WHO_foerst/structure.csv"
  )
  hads_str <- fread(
    "C:/Users/mphelps/Hjerteforeningen/Analyseenhed - R analyses - personal information/lmhs/Paaroerende_HADS_foerst/structure.csv"
  )
}
# Explore data
n_hads <- names(hads_complete)
n_who <- names(who_complete)
n_different_hads <- n_hads %in% n_who
n_different_who <- n_who %in% n_hads

n_hads[!n_different_hads]
n_who[!n_different_who]

n_hads[86:111]

# Looks like the questionName is the same in both datasets - perfect!
# grep("Jeg har følt det, som om jeg fungerede langsommere", n_who)
# grep("Jeg har følt det, som om jeg fungerede langsommere", n_hads)
if(patient){
who_str[233]
hads_str[224]
} else{
who_str[103]
hads_str[94]
}


x <- who_str$questionText %in% hads_str$questionText
y <- hads_str$questionText %in% who_str$questionText
x <- who_str[!x, questionName, questionText]

y <- hads_str[!y, questionName, questionText]


x <- x[, gsub("[0-9]", "", questionText)]
y <- y[, gsub("[0-9]", "", questionText)]
x %in% y

