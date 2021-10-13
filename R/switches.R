last_response_switch_pat <- function(q) {
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
