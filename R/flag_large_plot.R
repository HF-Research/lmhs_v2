# Flags when plots should be large (and thus sorted by higest to lowest and
# fliped x-y axis)
flag_large_plot <- function(x, strat, person_type, q) {
  never_large <-
    strat == "Kon/alder" |
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

  always_large <- (
    person_type == "paar" &
      (
        q == "18. Ikke tilbudt samtaler med psykolog" |
          q == "20.2.1 Brugte ferie på at få fri"

      )
  ) |
    (
      person_type == "pat" &
        (
          q == "25.2 Har ikke talt med lægen/hjertelægen om kosttilskud/naturlægemidler" |
            q == "47. Nedsat lyst til sex" |
            q == "50. Bekymringer pga. corona"
        )
    )
  if (always_large) {
    return(TRUE)
  }
  large_plot <- nrow(x) > 6
  large_plot
}
