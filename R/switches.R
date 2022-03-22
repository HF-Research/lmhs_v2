last_response_switch_pat <- function(q) {
  # For some of the battery items, we want to move a specific response to the
  # bottom of the plot. This is usually because we want the equivilant of a NA
  # resopnse to be shown at the bottom.
  switch (q,
          "6." = "Jeg har ikke haft",
          "12." = "Nej, jeg har ikke",
          "20.1" = "Nej, min",
          "20.2.3"="Nej, jeg har ikke",
          "25."="Jeg tager ingen")
}

last_response_switch_paar <- function(q) {
  switch (q,
          "20.1"="Nej, min")
}
