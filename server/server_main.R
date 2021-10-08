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

observeEvent(input$topic, {
  req(input$topic)
  question_choices <-
    d$q_by_topic_person[[paste0(input$person_type, ".", input$topic)]]
  freezeReactiveValue(input, "question_name_short")
  updateSelectizeInput(
    session,
    inputId = "question_name_short",
    label = choose_question,
    choices = question_choices,
    selected = question_choices[1]
  )
})

observeEvent(input$question_name_short, {
req(input$question_name_short)
  strat_choices <-
    d$strat_by_item[[paste0(input$person_type, ".", input$question_name_short)]]
  freezeReactiveValue(input, "strat")
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
  x <- input$strat
  y <- input$question_name_short
  isolate(d$dat[person_type == input$person_type &
                  topic_dk == input$topic &
                  question_name_short == input$question_name_short &
                  strat == input$strat])

})
# CASE --------------------------------------------------------------------
case <- reactive({
  req(input$question_name_short)
  hq <- F
  hq <- grepl("HeartQol", input$question_name_short)
  case <- "pat_svar"
  if (input$person_type == "paar")
    if (input$strat == "Kon/alder") {
      case <- "paar_age_sex"
    } else if (input$strat != "Svar fordeling") {
      case <- "paar_strat"
    } else{
      case <- "paar_svar"
    }

  else if (input$strat == "Kon/alder") {
    case <- "pat_age_sex"
    if (hq)
      case <- "pat_age_sex_mean"
  } else if (input$strat != "Svar fordeling") {
    case <- "pat_strat"
    if (hq)
      case <- "pat_strat_mean"
  }
  case
})
# PRETTY TEXT -------------------------------------------------------------
pretty_title <- reactive({
  plot_title <-
    stringr::str_wrap(plot_data()[1]$questionText, width = 75)
  plot_title
})

pretty_title_sub <- reactive({
  plot_title_sub <- ""
  if (input$strat != "Svar fordeling") {
    plot_title_sub <- plot_data()$response[1]
  } else if (plot_data()[, converted_binary == 1][1]) {
    plot_title_sub <- plot_data()$converted_binary_response[1]
  }
  plot_title_sub
})

output$outcome_title_dt  <- renderText({
  req(input$strat)
  pretty_title()
})

output$outcome_title_sub_dt <- renderText({
  req(input$question_name_short,
      input$strat,
      nrow(plot_data()) > 0)
pretty_title_sub()
})
output$outcome_title_map  <- renderText({
  req(input$strat)
  pretty_title()
})

output$outcome_title_sub_map <- renderText({
  req(input$question_name_short,
      input$strat,
      nrow(plot_data()) > 0)
  pretty_title_sub()
})


output$outcome_description <- renderUI({
  req(input$question_name_short,
      input$strat, nrow(plot_data()) > 0)

  x  <- gsub(pattern = "[0-9]", '', input$question_name_short)
  if (nchar(x) == 0)
    return(" ")
  x  <- gsub(pattern = "^.", '', x)
  x <- str_trim(x)

  out <-
    d$scales[var_name_short == x, .(var_name_new, text)]
  if (nrow(out) == 0)
    return("")

  out_title <- tags$b(out$var_name_new)
  tagList(out_title, out$text)
  # Add link for further reading - if link exists, otherwise just desc
  # url <- a(ui_read_more,
  #          href = (out$link),
  #          target = "_blank")
  #
  # if (out$link != "na") {
  #   tagList(out_title, out$desc, url)
  # }
  # else {
  #   tagList(out_title, out$desc)
  # }

})

large_plot <- reactive({
  flag_large_plot(x = plot_data(),
                  input$strat,
                  input$person_type,
                  input$question_name_short)
})

# PLOT --------------------------------------------------------------------

output$plot <- plotly::renderPlotly({
  req(
    input$topic,
    input$question_name_short,
    input$strat,
    nrow(plot_data()) > 0
  )

  input$strat
  input$question_name_short
  isolate({


  hq <- FALSE
  hq <- grepl("HeartQol", input$question_name_short)

  large_plot <- large_plot()

  # Title
  plot_title  <- pretty_title()
  plot_title_sub <- ""
  if (hq) {
    plot_title_sub <- "Max score er 3, højerer score er bedre"
  }
  else if (input$strat != "Svar fordeling") {
    plot_title_sub <- plot_data()$response[1]

  } else if (plot_data()[, converted_binary == 1][1]) {
    plot_title_sub <- plot_data()$converted_binary_response[1]
  }

  title_length <- nchar(plot_title)
  long_title <- title_length > 150 | nchar(plot_title_sub) > 1

  # Axis labels
  axis_title_y <- "Væget andel(%)"
  if (input$person_type == "paar") {
    axis_title_y <- "Andel(%)"
  } else if (hq) {
    axis_title_y <- "Væget mean"
  }


  axis_title_x <-
    plot_data()[, strat][1]
  if (input$strat == "Svar fordeling") {
    axis_title_x <- ""
  }

  # Formatting
  axis_font_size <- 20
  tick_font_size <- 15
  legend_font_size <- 20

  if (large_plot) {
    tmp <- axis_title_x
    axis_title_x <- axis_title_y
    axis_title_y <- tmp
    tick_font_size <- 13
  }


  # Action
  plot <- make_plotly(
    strat = input$strat,
    dat = plot_data(),
    q = input$question_name_short,
    large_plot = large_plot,
    axis_title_x = axis_title_x,
    num_digits = 1,
    hq = hq
  )
  format_plotly(
    plot_out = plot$plot,
    large_plot = large_plot,
    hq = hq,
    long_title = long_title,
    plot_title = plot_title,
    plot_title_sub = plot_title_sub,
    axis_title_x = axis_title_x,
    axis_title_y = axis_title_y,
    axis_font_size = axis_font_size,
    tick_font_size = tick_font_size,
    legend_font_size = legend_font_size,
    num_digits = 1
  )
})
})


# TABLES ------------------------------------------------------------------
output$table_rate <- renderDT({
  req(
    input$topic,
    input$question_name_short,
    input$strat,
    nrow(plot_data()) > 0
  )
  input$strat
  input$question_name_short
isolate({
  case <- case()

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
    "paar_svar" = col_titles2,
    "paar_age_sex" = col_titles2,
    "paar_strat" = col_titles2
  )


  dat <- switch(
    case,
    "pat_svar" = plot_data()[, .(response, percent, count)],
    "pat_age_sex" = plot_data()[, .(Kon, Alder, percent, count)],
    "pat_age_sex_mean" = plot_data()[, .(Kon, Alder, mean)],
    "pat_strat" = plot_data()[, .(strat_level, percent, count)],
    "pat_strat_mean" = plot_data()[, .(strat_level, mean)],
    "paar_svar" = plot_data()[, .(response, percent, count)],
    "paar_strat" = plot_data()[, .(strat_level, percent, count)],
    "paar_age_sex" = plot_data()[, .(Kon, Alder, percent, count)]
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
    "paar_svar" = c("Svar", data_cols),
    "paar_strat" = tmp,
    "paar_age_sex" = age_sex_tmp
  )

  dt_title <- pretty_title()
  if (large_plot()) {
    setorder(dat, -percent)
  }

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
    digits = 1,
    case = case
  )
})
})

# MAPS --------------------------------------------------------------------

map_data_obj <- reactive({
  browser()
  dat <-
    copy(plot_data()) # Make copy so not corrupt reactive data

  map_data(
    dat = dat,
    data_var = "percent",
    map_obj = mapObj()
  )
})

output$map <- renderLeaflet({
  browser()
  req(input$strat, input$question_name_short, nrow(plot_data()>0))

  map_data_obj()

})

