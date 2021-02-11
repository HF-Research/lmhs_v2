output$question_choices <- renderUI({
  req(input$respondend_type)

  # Gives a dynamic button UI. The buttons change depending on the selected
  # outcome Keep variables that have "count" in their name.
  #
  # This next code allows the variable chosen by the user to remain, when
  # switching to a new outcome, while on a aggr_level not supported with the new
  # outcome. F.x. Switch from all-CVD, 30-day mortality, kommune-level, to
  # hjerteklapoperation. Hjerteklaoperation only supports 30-day mort at
  # national level, so the variable is switched to incidence.
  #
  # If the previous selected var is not available, test to see if it is
  # available in the previously selected aggr_level. If not to both, set
  # selected_var to be the first variable.

  question_choices_out <-
    make_var_choices(
      selected_var = (validateSelectedVars()$selected_var),
      var_names = (validateSelectedVars()$var_names),
      valid_selection = (validateSelectedVars()$valid_selection),
      aggr_selected_next = aggr_selected_next,
      outcome_code = input$oCVD,
      valid_output_combos = valid_output_combos
    )

  selectInput(
    inputId = "question_choices",
    label = choose_question,
    choices = question_choices_out$var_names,
    selectize = TRUE,
    selected = question_choices_out$selected_var
  )
})
