# UI INPUT ----------------------------------------------------------------

observeEvent(input$person_type, {
  topic_choices <- d$topics_by_person[[input$person_type]]

  updateSelectizeInput(
    session,
    inputId = "topic",
    label = choose_topic,
    choices = topic_choices,
    selected = topic_choices[1]
  )

})

listen_question <- reactive({

  list(input$person_type, input$topic)
})
observeEvent(listen_question(), {
  req(input$topic)

  question_choices <-
    d$q_by_topic_person[[paste0(input$person_type, ".", input$topic)]]
  updateSelectizeInput(
    session,
    inputId = "question_name_short",
    label = choose_question,
    choices = question_choices,
    selected = question_choices[1]
  )
})
listen_strat <- reactive({
  list(input$person_type, input$question_name_short, input$topic)
})
observeEvent(listen_strat() , {
  req(input$question_name_short)

  strat_choices <-
    d$strat_by_item[[paste0(input$person_type, ".", input$question_name_short)]]
  updateRadioGroupButtons(
    session,
    inputId = "strat",
    label = choose_stratification,
    choices = strat_choices,
    selected = strat_choices[1]
  )
})


# DATA --------------------------------------------------------------------

plot_data <- reactive({
  d$dat[person_type == input$person_type &
          topic_dk == input$topic &
          question_name_short == input$question_name_short &
          strat == input$strat]
})



# PRETTY TEXT -------------------------------------------------------------
pretty_title <- reactive({
  plot_title <-
    stringr::str_wrap(plot_data()[1]$questionText, width = 75)
})

output$outcome_title_dt  <- renderText(pretty_title())
# PLOT --------------------------------------------------------------------

output$plot <- plotly::renderPlotly({
  req(
    input$person_type,
    input$topic,
    input$question_name_short,
    input$strat,
    nrow(plot_data()) > 0
  )

  axis_title_y <- "Væget andel(%)"
  if (input$person_type == "paar") {
    axis_title_y <- "Andel(%)"
  }

  plot_title  <- pretty_title()
  if (input$strat != "Svar fordeling") {
    plot_title <- paste0(plot_title, " ", plot_data()$response[1])
  }


  title_length <- nchar(plot_title)
  long_title <- title_length > 150
  large_plot <- nrow(plot_data()) > 6
  if (input$strat == "Kon/alder")
    large_plot <- FALSE
  axis_title_x <-
    plot_data()[, strat][1]
  axis_font_size <- 20
  tick_font_size <- 15
  legend_font_size <- 20

  plot <- make_plotly(
    strat = input$strat,
    dat = plot_data(),
    q = input$question_name_short,
    large_plot = large_plot,
    axis_title_x = axis_title_x,
    num_digits = 1
  )
  format_plotly(
    plot_out = plot$plot,
    large_plot = large_plot,
    hq = plot$hq,
    long_title = long_title,
    plot_title = plot_title,
    axis_title_x = plot$axis_title_x,
    axis_title_y = axis_title_y,
    axis_font_size = axis_font_size,
    tick_font_size = tick_font_size,
    legend_font_size = legend_font_size,
    num_digits = 1
  )

})


# TABLES ------------------------------------------------------------------
output$table_rate <- renderDT({
  req(
    input$person_type,
    input$topic,
    input$question_name_short,
    input$strat,
    nrow(plot_data()) > 0
  )
  hq <- F
  hq <- grepl("hq_", input$question_name_short)
  case <- "pat_svar"
  if (input$person_type == "paar")
    if(input$strat=="Kon/alder"){
      case <- "paar_age_sex"
    }else if(input$strat!="Svar fordeling"){
      case <- "paar_strat"
    }else{
      case <- "paar_svar"
    }

  else if (input$strat == "Kon/alder") {
    case <- "pat_age_sex"
    if (hq)
      case <- "pat_age_sex_hq"
  } else if (input$strat != "Svar fordeling") {
    case <- "pat_strat"
    if (hq)
      case <- "pat_strat_hq"
  }
  col_titles1 <- c("Væget andel(%)", "Væget antal")
  col_titles2 <- c("Andel(%)", "Antal")
  col_titles_mean <- c("Væget mean")


  data_cols <- switch(
    case,
    "pat_svar" = col_titles1,
    "pat_age_sex" = col_titles1,
    "pat_age_sex_mean" = col_titles_mean,
    "pat_strat" = col_titles1,
    "pat_strat_mean" = col_titles_mean,
    "paar_svar" = col_titles1,
    "paar_age_sex" = col_titles1,
    "paar_svar" = col_titles1
  )


  dat <- switch(
    case,
    "pat_svar" = plot_data()[, .(response, percent, count)],
    "pat_age_sex" = plot_data()[, .(Kon, Alder, count, percent)],
    "pat_age_sex_mean" = plot_data()[, .(Kon, Alder, mean)],
    "pat_strat" = plot_data()[, .(strat_level, percent, count)],
    "pat_strat_mean" = plot_data()[, .(strat_level, mean)],
    "paar_svar" = plot_data()[, .(response, percent, count)],
    "paar_strat" = plot_data()[, .(strat_level, percent, count)],
    "paar_age_sex" = plot_data()[, .(Kon, Alder, count, percent)]
  )

  tmp <- c(plot_data()$strat[1], data_cols)
  age_sex_tmp <- c("Kon", "Alder", data_cols)
  col_titles <- switch(
    case,
    "pat_svar" = c("Svar", data_cols),
    "pat_age_sex" = age_sex_tmp,
    "pat_age_sex_mean" = age_sex_tmp,
    "pat_strat" = tmp,
    "pat_strat_mean" = tmp,
    "paar_svar" =c("Svar", data_cols),
    "paar_strat" = tmp,
    "paar_age_sex" = age_sex_tmp
  )

  dt_title <- pretty_title()

  names(dat) <- col_titles
  messageTop = "t"
  messageBottom = "bottom"
  n_col <- ncol(dat)


    make_dt_rate(
      dat = dat,
      col_titles = col_titles,
      dt_title = dt_title,
      messageTop = messageTop,
      n_col = n_col,
      messageBottom = messageBottom,
      thousands_sep = thousands_sep,
      dec_mark = dec_mark,
      digits = 1
    )
})
