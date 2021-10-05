make_strat_choices <- function(d, person_type,
                               question_name_short) {

  x <- names(d$strat_by_item)

  choice <- x[grepl(question_name_short,x) &grepl(person_type,x)]
  strat_choices <-
    d$strat_by_item[[choice]]
}
