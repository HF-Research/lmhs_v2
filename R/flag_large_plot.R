# Flags when plots should be large (and thus sorted by higest to lowest and
# fliped x-y axis)
flag_large_plot <- function(x, strat, person_type, q) {
  never_large <-
    strat == "Køn/alder" |
    (
      person_type == "paar" &
        (
          q == "14. Opfordret til at tale om bekymringer" |
            q == "13. Uforståeligt sprog"
        )
    )
  if (never_large) {
    return(FALSE)
  }

  always_large <- x$converted_binary[1] == 1
  if (always_large)
    return(TRUE)
  return(nrow(x) > 6)
}
